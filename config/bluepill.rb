Bluepill.application('shodan') do |app|
  app.process('shodan') do |process|
    process.start_command = File.join(File.expand_path(File.dirname(__FILE__)), "../bin/shodan")
    process.pid_file      = "/tmp/shodan.pid"
    process.daemonize     = true
    process.working_dir = "/home/pi/shodan"
    process.stdout = process.stderr = "/tmp/shodan.log"
  end
end
