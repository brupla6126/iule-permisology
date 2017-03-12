# encoding: utf-8

config = YAML.load_file("#{PermisologyService.root}/config/logging.yml")

formatters = {
  simple: proc do |severity, _datetime, _progname, msg|
            "#{severity.rjust(5)} | #{msg}\n"
          end,
  date_time: proc do |severity, datetime, _progname, msg|
               date_format = datetime.strftime('%Y-%m-%d %H:%M:%S')
               "#{date_format} #{severity.rjust(5)} | #{msg}\n"
             end,
  date_time_ms: proc do |severity, datetime, _progname, msg|
                  date_format = datetime.strftime('%Y-%m-%d %H:%M:%S.%L')
                  "#{date_format} #{severity.rjust(5)} | #{msg}\n"
                end,
  time_ms: proc do |severity, datetime, _progname, msg|
             date_format = datetime.strftime('%H:%M:%S.%L')
             "#{date_format} #{severity.rjust(5)} | #{msg}\n"
           end
}

if config['loggers']
  config['loggers'].each do |logger_name, params|
    rotation = params['rotation'] || 'daily'

    logger = case params['output']
      when 'console' then Logger.new(STDOUT)
      when 'file' then Logger.new("log/#{logger_name}.log", rotation)
      end

    logger.level = case params['level']
      when 'debug' then Logger::DEBUG
      when 'info' then Logger::INFO
      when 'warn' then Logger::WARN
      when 'error' then Logger::ERROR
      when 'fatal' then Logger::FATAL
      else Logger::WARN
    end

    if params['formatter']
      formatter = formatters[params['formatter'].to_sym] || formatters[:simple]
      logger.formatter = formatter if formatter
    end

    Log[logger_name.to_sym] = logger
  end
end
