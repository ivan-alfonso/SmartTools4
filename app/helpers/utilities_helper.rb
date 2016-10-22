require 'date'

module UtilitiesHelper

	def build_date_from_params(params, search_object, search_date)

        anio = params[search_object][search_date + "(1i)"]
        mes  = params[search_object][search_date + "(2i)"]
        dia  = params[search_object][search_date + "(3i)"]		

		return Date.new(anio.to_i, mes.to_i, dia.to_i)

	end

	def build_date_from_hash(hash_params, search_date)

        anio = hash_params[search_date + "(1i)"]
        mes  = hash_params[search_date + "(2i)"]
        dia  = hash_params[search_date + "(3i)"]		

		return Date.new(anio.to_i, mes.to_i, dia.to_i)

	end

end