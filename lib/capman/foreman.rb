Capistrano::Configuration.instance(:must_exist).load do |configuration|

  namespace :foreman do
    desc "Export the Procfile to Ubuntu's upstart scripts"
    task :export, :roles => :app do
      commands = [
        "mkdir -p /tmp/export",
        "cd #{current_path}",
        "bundle exec foreman export upstart /tmp/export -f Procfile -a #{application} -e /home/#{application}/.env -u #{user} -l #{shared_path}/log",
        "#{sudo} rm -rf /etc/init/#{application}*.conf",
        "#{sudo} cp /tmp/export/#{application}*.conf /etc/init/"
      ]
      run commands.join(" && ")
    end

    desc "Start the application services"
    task :start, :roles => :app do
      sudo "start #{application}"
    end

    desc "Stop the application services"
    task :stop, :roles => :app do
      sudo "stop #{application}"
    end

    desc "Restart the application services"
    task :restart, :roles => :app do
      run "#{sudo} start #{application} || #{sudo} restart #{application}"
    end
  end

  after "deploy:update", "foreman:export"
  after "deploy:update", "foreman:restart"
end