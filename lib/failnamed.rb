# Copyleft meh. [http://meh.doesntexist.org | meh@paranoici.org]
#
# This file is part of failnamed.
#
# failnamed is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# failnamed is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with failnamed. If not, see <http://www.gnu.org/licenses/>.

require 'faildns/server'
require 'faildns/client'

require 'failnamed/zones'

module DNS

class Named
	attr_reader :server, :client

	def initialize (config = nil)
		@server = DNS::Server.new
		@client = DNS::Client.new
		@zones  = zones.new

		@server.input do |socket, message, response|
			response.header = DNS::Header.new {|h|
				h.id = message.header.id

				h.type  = :RESPONSE
				h.class = :QUERY
			}

			catch(:return) {
				message.questions.each {|question|
					zones.answer question, response, message
				}
			}
		end

		load_config config if config
	end

	def load_config (path)
		instance_eval File.read(File.expand_path(path)), path, 1
	end

	def start
		if @server.listens_on.empty?
			listen '0.0.0.0', 53
		end

		@server.start
	end

	def stop
		@server.stop
	end

	def before (&block)
		@server.input &block
	end

	def after (&block)
		@server.output &block
	end

	def listen (type = :udp, host, port)
		@server.listen(type, host, port)
	end

	def forward_to (*what)
		what.flatten.compact.each {|what|
			if IP.valid?(what)
				@client.servers << what
			else
				@client.resolve(what).values.each {|ips|
					ips.each {|ip|
						@client.servers << ip
					}
				}
			end
		}
	end

	def zones (&block)
		block ? @zones : @zones.do(&block)
	end
end

end
