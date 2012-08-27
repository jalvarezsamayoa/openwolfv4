source 'https://rubygems.org'

gem 'rails', '3.2.7'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg'

# Servidor
gem 'thin'

# AUTENTICACION
gem 'devise' # libreria de autenticacion
gem 'acl9' # libreria de manejo de roles de usuario
gem 'cancan' #libreria manejo de accesos a recursos

# Active Record
gem 'awesome_nested_set'

# HELPERS
gem 'haml' # sistema para generacion de templates
gem 'haml-rails'
gem 'nokogiri'
gem 'hpricot'
gem 'ruby_parser'

# Controllers
gem 'inherited_resources' #encapsula operaciones basicas para controladores

# VIEWS
gem "simple_form", "~> 2.0.2"
gem 'tinymce-rails' # editor html
gem 'wicked_pdf' # generacion de pdf
gem 'will_paginate' # pagineo de resultados
gem 'jquery-rails' #jquery para rails, remplaza prototype y scriptaculous
gem 'paperclip' # modulo para hacer upload a archivos
gem 'galetahub-simple_captcha', :require => 'simple_captcha', :git => 'git://github.com/galetahub/simple-captcha.git'
gem "crummy", "~> 1.6.0" # manejo de breadcrumbs
gem 'client_side_validations' #validacion javascript para forms

# INDEXAMIENTO
gem 'pg_search'
#gem 'searchlogic'


# HERRAMIENTAS
gem 'whenever' # manejo de cronjobs
gem 'activerecord-import', '~> 0.2.9' # herramienta para importacion de data
gem 'serenity-odt' #generacion de templates ODT
gem 'fastercsv' #manejo de archivos CSV
gem 'progress_bar' # muestra barra progreso en consola

gem 'daemons'
gem 'delayed_job_active_record'
gem "delayed_job", "~> 3.0.3" # envia procesos a background - en uso para enviar correos

#gem 'dalli' # interfaz con servicio de almacenamiento de cache de objetos Memcached - memcached.org
gem 'backup' #libreria para generar backups de aplicacion

# MONITOREO
gem 'newrelic_rpm' # monitoreo de performance http://newrelic.com
gem 'airbrake' #notificacion de errores via http://hoptoadapp.com/

# Generacion de Imagenes
gem 'rmagick'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'

  gem 'twitter-bootstrap-rails',  :git => 'git://github.com/seyhunak/twitter-bootstrap-rails.git'
end


group :development, :test do
  gem 'highline'
  gem 'pry'
  gem 'silent-postgres' #elimina la salida de el log de postgresql
  gem 'faker' # herramienta para generacion de datos de prueba
  gem 'ruby-prof'
  gem 'annotate', :git => 'git://github.com/ctran/annotate_models.git'
  gem 'foreman'
  gem 'guard'
  gem 'guard-livereload'
  gem 'guard-bundler'
  gem 'guard-rails'
  gem 'guard-delayed'
  gem 'rb-inotify'
  gem 'libnotify'
  gem 'debugger'
  gem 'rvm-capistrano'
  gem 'quiet_assets'


  # DEPLOYMENT
  gem 'capistrano' # herramienta para hacer deployment de la aplicacion
end



# TESTING
group  :test do

  gem "rspec-rails",        :git => "git://github.com/rspec/rspec-rails.git"
  gem "rspec",              :git => "git://github.com/rspec/rspec.git"
  gem "rspec-core",         :git => "git://github.com/rspec/rspec-core.git"
  gem "rspec-expectations", :git => "git://github.com/rspec/rspec-expectations.git"
  gem "rspec-mocks",        :git => "git://github.com/rspec/rspec-mocks.git"


  gem "capybara"
  gem "factory_girl_rails"
  gem "launchy"

  gem 'rb-inotify'
  gem 'libnotify'
  gem 'test_notifier'

  gem 'ZenTest'

  gem "spork"

  gem 'email_spec'
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
