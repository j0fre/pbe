
require 'mfrc522'
class Rfid

	def read_uid	
		puts "Passi la targeta/clauer sisplau"
		r = MFRC522.new
		id="no llegit encara"
		until id!="no llegit encara" #quan s'hagi llegit la targeta, aquesta variable deixarà de valdre 0
			begin
				r.picc_request(MFRC522::PICC_REQA)
				id, sak = r.picc_select 
				break
				
			rescue UnexpectedDataError, CommunicationError #encara no s'ha passat la target, que torni a intentar llegir-la
				
			end
		end
		
		s = String.new
		for i in 0..id.size-1
			s = s + id[i].to_bytehex #el vector de 4 números en decimal que s'ha llegit de la targeta, es passa a hexadecimal cada valor per separat
			#i s'afegeix al string que es retornarà
		end
		return "UID: #{s}"	
	end
end


if __FILE__==$0	
	rf=Rfid.new()
	uid=rf.read_uid
	puts uid	
end


