# Ruby module to use Pashua (www.bluem.net/jump/pashua).
# For more info, see https://github.com/BlueM/Pashua-Binding-Ruby

require 'tempfile'

module Pashua

  def pashua_run(script, path = '')
    pbin = pashua_locate(path) or return nil
    res = Hash.new
    tmp = Tempfile.open('Pashua')
    tmp.puts script
    tmp.close
    IO.popen("'" + pbin + "' " + tmp.path).each do |s|
      key, val = s.chomp.split('=', 2)
      res[key] = val
    end
    return res
  end

  def pashua_locate(path = '')
    locations = [File.dirname($0), $0, '.', '/', '/Applications', File.expand_path('~/Applications')]
    locations = [path] + locations if path != ''
    for d in locations
      p = File::join(d, 'Pashua')
      return p if File::executable?(p)
      p = File::join(d, 'Pashua.app/Contents/MacOS/Pashua')
      return p if File::executable?(p)
    end
    $stderr.puts "Cannot find Pashua binary"
    return nil
  end

end
