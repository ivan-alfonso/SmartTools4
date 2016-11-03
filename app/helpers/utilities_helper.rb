require 'date'

module UtilitiesHelper

    include AwsSqsHelper	

    # convierte una fecha desde los parametros del controller
	def build_date_from_params(params, search_object, search_date)

        anio = params[search_object][search_date + "(1i)"]
        mes  = params[search_object][search_date + "(2i)"]
        dia  = params[search_object][search_date + "(3i)"]		

		return Date.new(anio.to_i, mes.to_i, dia.to_i)

	end

    # convierte una fecha a partir del hash de los params
	def build_date_from_hash(hash_params, search_date)

        anio = hash_params[search_date + "(1i)"]
        mes  = hash_params[search_date + "(2i)"]
        dia  = hash_params[search_date + "(3i)"]		

		return Date.new(anio.to_i, mes.to_i, dia.to_i)

	end

    # realiza la carga de un archivo
    def upload_file( id_object, file_to_upload, folder_on_s3 )
        
        file_name = id_object.to_s + "-" + file_to_upload.original_filename.to_s
        path_uploaded_files = Rails.root.join('public','uploaded-files')
        uploaded_file = path_uploaded_files.to_s + "/" + file_name

         unless Dir.exist?(path_uploaded_files)
            FileUtils.mkdir_p(path_uploaded_files)
         end

        File.open(uploaded_file, 'wb') do |file|
          file.write(file_to_upload.read)
        end        

        file_on_s3 = folder_on_s3 + "/" + file_name
        upload_file_to_aws_s3(uploaded_file, file_on_s3)

        FileUtils.rm(uploaded_file.to_s)

=begin
                s3 = Aws::S3::Resource.new(
            credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']),
            region: ENV['AWS_REGION']
        )
file_to_upload = Rails.root.join('public','PortadaImag','Im1.jpg')
        obj = s3.bucket(ENV['S3_BUCKET_NAME']).object('images/imageprueba')
        obj.upload_file(file_to_upload, acl:'public-read')
        obj.public_url
=end

    end

end