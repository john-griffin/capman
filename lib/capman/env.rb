require "capman/environment"

Capistrano::Configuration.instance(:must_exist).load do |configuration|
  namespace :env do
    set(:environment_file) { "/home/#{application}/.env" }

    desc 'View the current server environment'
    task :default do
      if current_environment.empty?
        puts "There are no config variables set"
      else
        puts "The config variables are:"
        puts
        puts current_environment
      end
    end

    desc 'Set a variable in the environment, using "cap env:set VARIABLE=VALUE".  Unset using "cap env:set VARIABLE="'
    task :set do
      env = env_argv.inject(current_environment) do |env, string|
        env.set_string(string)
        logger.debug "Setting #{string}"
        logger.debug "Env is now: #{env}"
        env
      end
      update_remote_environment(env)
      default
    end

    def current_environment
      @current_environment ||= begin
        if deployed_file_exists?(environment_file, '.')
          Capman::Environment.from_string(capture("cat #{environment_file}"))
        else
          Capman::Environment.new
        end
      end
    end

    def deployed_file_exists?(path, root_path = deploy_to)
      exit_code("cd #{root_path} && [ -f #{path} ]") == "0"
    end

    def exit_code(command)
      capture("#{command} > /dev/null 2>&1; echo $?").strip
    end

    def update_remote_environment(env)
      logger.debug "Env is now #{env}"

      default_env.each do |name, value|
        env.set(name, value) unless env.get(name)
      end

      if env.empty?
        run "rm -f #{environment_file}"
      else
        put_as_app env.to_s, environment_file
      end
    end

    def set_default_env(name, value)
      default_env[name.to_s] = value
    end

    def default_env
      @default_env ||= {}
    end

    def env_argv
      ARGV[1..-1]
    end

    def put_as_app(string, path)
      put string, "/tmp/put-as-app", via: :scp
      run "cp /tmp/put-as-app #{path} && chmod g+rw #{path}"
      run "rm /tmp/put-as-app"
    end

  end
end