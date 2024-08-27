output "instance_id" {
  value = aws_instance.my-neww-instance.id
}

output "bucket_name" {
  value = aws_s3_bucket.my_buckett.bucket
}

