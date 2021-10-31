require 'llegiruid'
require 'gtk3'


class Finestra < Gtk::Window
		def initialize
		super
		set_title "Welcome"
		set_default_size 400,150
		set_border_width 7
		set_window_position Gtk::WindowPosition::CENTER
		
		@rf=Rfid.new()
		
		container=Gtk::Box.new(:vertical,7)
		add(container)
		
		css_inicial = Gtk::CssProvider.new
		css_inicial.load(data: File.read("estil_inicial.css"))
		@css_tpassada = Gtk::CssProvider.new
		@css_tpassada.load(data: File.read("targeta_passada.css"))
		@uid=""
	
		@label=Gtk::Label.new("Please, login with your university card")
		@label.style_context.add_provider(css_inicial, Gtk::StyleProvider::PRIORITY_USER)
		container.pack_start(@label, :expand => true, :fill=> true)

		@button= Gtk::Button.new(:label => 'Clear')
		@button.set_sensitive(false)
		@button.style_context.add_provider(css_inicial, Gtk::StyleProvider::PRIORITY_USER)
		@button.signal_connect "clicked" do |_widget|
			@label.style_context.add_provider(css_inicial, Gtk::StyleProvider::PRIORITY_USER)
			@label.set_text("Please, login with your university card")
			@button.set_sensitive(false)
			fil
		end	
		container.pack_start(@button,:expand => false, :fill=>true)		
		
		def canviPantalla			
				
				if @uid!=""
					@label.style_context.add_provider(@css_tpassada, Gtk::StyleProvider::PRIORITY_USER)
					@label.set_text("uid: #{@uid}")
					@button.set_sensitive(true)
				end			
		end
		canviPantalla
		
		def llegir	
			@uid=""
			@uid=@rf.read_uid()			
			GLib::Idle.add{
				canviPantalla
				while @uid==""
					canviPantalla
				end
			}				
		end
		
		def fil
			filn=Thread.new {llegir}			
		end
		fil
		
		signal_connect("delete-event") {|_widget|  Gtk.main_quit }
		show_all		
	end
end

if __FILE__==$0
	fin = Finestra.new()	
	Gtk.main
end


