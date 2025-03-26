import boto3
import json
import os
from botocore.exceptions import ClientError
from config import AWS_REGION, SQS_QUEUE_URL

def get_sqs_client():
    """Returns an SQS client configured with AWS credentials"""
    return boto3.client('sqs', region_name=AWS_REGION)

def send_message_to_queue(message_data):
    """
    Send a message to the SQS queue
    
    Args:
        message_data (dict): The message content to be sent to the queue
        
    Returns:
        dict: The response from SQS
    
    Raises:
        ClientError: If there's an error communicating with SQS
    """
    client = get_sqs_client()
    queue_url = SQS_QUEUE_URL
    
    if not queue_url:
        raise ValueError("SQS_QUEUE_URL environment variable is not set")
    
    try:
        response = client.send_message(
            QueueUrl=queue_url,
            MessageBody=json.dumps(message_data)
        )
        return response
    except ClientError as e:
        print(f"Error sending message to SQS: {e}")
        raise