package main

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"log"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/timestreamwrite"
	"github.com/aws/aws-sdk-go-v2/service/timestreamwrite/types"
)

type handler struct {
	c *timestreamwrite.Client
}

func main() {
	cfg, err := config.LoadDefaultConfig(context.Background())
	if err != nil {
		log.Panic("Error loading default config")
	}
	c := timestreamwrite.NewFromConfig(cfg)

	lambdaHandler := &handler{c}
	lambda.Start(lambdaHandler.Handle)
}

func (h handler) Handle(_ context.Context, kinesisEvent events.KinesisEvent) {
	kinesisRecords := make([]map[string]string, len(kinesisEvent.Records))

	log.Printf("Event received on lambda with %d records", len(kinesisEvent.Records))
	log.Println(kinesisEvent.Records)

	for i, record := range kinesisEvent.Records {
		x := map[string]string{}

		err := json.Unmarshal(record.Kinesis.Data, &x)
		if err != nil {
			log.Println(err)
			continue
		}
		kinesisRecords[i] = x
	}

	log.Println(kinesisRecords)

	records := kinesisRecordsToTimestreamRecords(kinesisRecords)
	_, err := h.c.WriteRecords(context.Background(), &timestreamwrite.WriteRecordsInput{
		DatabaseName: aws.String("opg-metrics"),
		Records:      records,
		TableName:    aws.String("opg-metrics"),
	})

	if err != nil {
		var rejectedErr *types.RejectedRecordsException
		if errors.As(err, &rejectedErr) {
			fmt.Println("One or more records were rejected:")
			successfulCount := len(kinesisRecords) - len(rejectedErr.RejectedRecords)
			log.Printf("Successfully wrote %d out of %d records to timestream", successfulCount, len(kinesisRecords))

			for _, rejectedRecord := range rejectedErr.RejectedRecords {
				log.Printf("Record Index: %d, Reason: %s", rejectedRecord.RecordIndex, *rejectedRecord.Reason)
				if rejectedRecord.ExistingVersion != nil {
					log.Printf("  Existing Version: %d", *rejectedRecord.ExistingVersion)
				}
			}
		} else {
			log.Println("WriteRecords failed:", err)
		}
	} else {
		log.Printf("Successfully wrote all %d records to timestream", len(kinesisRecords))
	}
}

func kinesisRecordsToTimestreamRecords(kinesisRecords []map[string]string) []types.Record {
	records := make([]types.Record, 0, len(kinesisRecords))
	for _, kinesisRecord := range kinesisRecords {
		dimensions := make([]types.Dimension, 0)
		for key, value := range kinesisRecord {
			if !isMandatoryData(key) {
				dimensions = append(dimensions, types.Dimension{Name: aws.String(key), Value: aws.String(value)})
			}
		}

		record := types.Record{
			Dimensions:       dimensions,
			MeasureName:      aws.String(kinesisRecord["MeasureName"]),
			MeasureValue:     aws.String(kinesisRecord["MeasureValue"]),
			MeasureValueType: types.MeasureValueTypeDouble,
			Time:             aws.String(kinesisRecord["Time"]),
			TimeUnit:         types.TimeUnitMilliseconds,
		}
		records = append(records, record)

	}
	return records
}

func isMandatoryData(key string) bool {
	switch key {
	case
		"MeasureName",
		"MeasureValue",
		"MeasureValueType",
		"Time":
		return true
	}
	return false
}
