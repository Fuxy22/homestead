# Main Homestead Class
class Addons
  def self.configure(config, settings)

    # Configure Local Variable To Access Scripts From Remote Location
    script_dir = File.dirname(__FILE__)

    nginx = true
    if settings.include? 'sites'

    settings['sites'].each do |site|

        type = site['type'] ||= 'laravel'

        case type
        when 'apigility'
          type = 'zf'
        when 'expressive'
          type = 'zf'
        when 'symfony'
          type = 'symfony2'
        end

        if type == 'apache'
          nginx = false
        end
      end
    end

    config.vm.provision 'shell', run: "always" do |s|
      s.name = 'Restart Nginx'
      s.path = script_dir + '/server-reset.sh'
      s.args = [nginx.to_s.downcase]
    end

    # Import CA cert into host trusted repository if desired
    if settings.has_key?('import_ca') && settings['import_ca']
      config.trigger.after :up do |trigger|
        trigger.info = "Copying CA files to share..."
        trigger.run_remote = {path: script_dir + "/share-ca.sh"}
      end

      config.trigger.after :up do |trigger|
        trigger.info = "Importing CA files..."
        trigger.run = {path: script_dir + "/import-ca.sh"}
      end

      config.trigger.after :destroy, :halt do |trigger|
        trigger.info = "Removing CA files..."
        trigger.run = {path: script_dir + "/remove-ca.sh"}
      end
    end

  end
end
