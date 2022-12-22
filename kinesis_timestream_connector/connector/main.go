package main

import (
	"context"
	"encoding/json"
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

func (h handler) Handle(ctx context.Context, kinesisEvent events.KinesisEvent) {
	kinesisRecords := make([]map[string]string, len(kinesisEvent.Records))

	log.Println("Event recieved on lambda with", len(kinesisEvent.Records), "records")

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
	h.c.WriteRecords(context.Background(), &timestreamwrite.WriteRecordsInput{
		DatabaseName: aws.String("opg-metrics"),
		Records:      records,
		TableName:    aws.String("opg-metrics"),
	})
}

func kinesisRecordsToTimestreamRecords(kinesisRecords []map[string]string) []types.Record {
	records := make([]types.Record, 0)
	for _, kinesisRecord := range kinesisRecords {
		dimensions := make([]types.Dimension, 0)
		for key, value := range kinesisRecord {
			if !isMandatoryData(key) {
				dimensions = append(dimensions, types.Dimension{Name: &key, Value: &value})
			}
		}
		records = append(records, types.Record{
			Dimensions:       dimensions,
			MeasureName:      aws.String(kinesisRecord["MeasureName"]),
			MeasureValue:     aws.String(kinesisRecord["MeasureValue"]),
			MeasureValueType: types.MeasureValueTypeDouble,
			Time:             aws.String(kinesisRecord["Time"]),
			TimeUnit:         types.TimeUnitMilliseconds,
		})

	}
	return records
}

func isMandatoryData(key string) bool {
	switch key {
	case
		"MeasureName",
		"MeasureValue",
		"Time":
		return true
	}
	return false
}
