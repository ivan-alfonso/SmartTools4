require 'aws-sdk'

module AwsSqsHelper

    # envia mensajes a una cola de aws
	def send_msg_to_queue(message)
		Rails.logger.info(" #{Time.now} Ide video: " + message)
		Rails.logger.info(" #{Time.now} url sqs: " + ENV['AWS_SQS_ORIGINAL_VIDEOS'])
		sqs = Aws::SQS::Client.new(region: ENV['AWS_REGION'])
		resp = sqs.send_message(queue_url: ENV['AWS_SQS_ORIGINAL_VIDEOS'], message_body: message)
	end

    # obtiene un mensaje de una cola de aws
	def obtain_message_from_queue
		sqs = Aws::SQS::Client.new(region: ENV['AWS_REGION'])
		resp = sqs.receive_message(queue_url: ENV['AWS_SQS_ORIGINAL_VIDEOS'], max_number_of_messages: 1)
		return resp.messages
	end

    # elimina un mensaje de una cola aws
	def delete_message_from_queue(receipt_handle)
		sqs = Aws::SQS::Client.new(region: ENV['AWS_REGION'])
		resp = sqs.delete_message(queue_url: ENV['AWS_SQS_ORIGINAL_VIDEOS'], receipt_handle: receipt_handle)
	end	

	# obtiene el numero de mensajes que hay en la cola SQS
	def count_messages_from_queue()
		sqs = Aws::SQS::Client.new(region: ENV['AWS_REGION'])
		resp = sqs.get_queue_attributes({
      		queue_url: ENV['AWS_SQS_ORIGINAL_VIDEOS'],
      		attribute_names: ["ApproximateNumberOfMessages"],
    	})
		return resp.attributes["ApproximateNumberOfMessages"]
	end

    # sube un archivo a s3
	def upload_file_to_aws_s3(file_to_upload, file_on_s3)

        s3 = Aws::S3::Resource.new(
            credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']),
            region: ENV['AWS_REGION']
        )

        obj = s3.bucket(ENV['S3_BUCKET_NAME']).object(file_on_s3)
        obj.upload_file(file_to_upload, acl:'public-read')
        obj.public_url
        file_on_cloud_front = ENV['AWS_CLOUD_FRONT'] + file_on_s3

        return file_on_cloud_front

	end

    # descarga un archivo de s3
	def download_file_from_aws_s3(file_to_download, file_on_local)

        s3 = Aws::S3::Resource.new(
            credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']),
            region: ENV['AWS_REGION']
        )

        s3.bucket(ENV['S3_BUCKET_NAME']).object(file_to_download).get(response_target: file_on_local.to_s)
        
	end	

end