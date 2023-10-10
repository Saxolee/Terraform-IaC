# Create SQS Resource block for SQS Queue
resource "aws_sqs_queue" "sts-storage-sqs" {
    name                       = "sts-storage-sqs"
    delay_seconds              = vars.sts_sqs_delay_seconds 
    max_message_size           = vars.sts_sqs_max_message_size 
    message_retention_seconds  = vars.sts_sqs_message_retention_seconds 
    visibility_timeout_seconds = vars.sts_sqs_visibility_timeout_seconds 
    receive_wait_time_seconds  = vars.sts_sqs_receive_wait_time_seconds
}
