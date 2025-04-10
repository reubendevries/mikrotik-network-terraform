variable "project" {
	type = "string"
	description = "The project name"
}

variable dynamodb_table_name {
	type = string
	default = "The DynamoDB table name"
}

variable bucket_name {
	type = string
	default = "The S3 bucket name"
}
