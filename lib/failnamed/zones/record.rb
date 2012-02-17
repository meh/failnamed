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

module DNS; class Named; class Zones < Hash

class Record
  attr_reader :zone, :options

	def initialize (zone, options = {} &block)
    @zone    = zone
		@options = options
		@matches = []

		instance_eval &block
	end

	def matches (what)
		@matches << what
	end

	def matches? (string)
		@matches.any? {|matcher|
			if matches.is_a?(Regexp)
				string.match(matcher)
			else
				string.match(/#{Regexp.escape(matcher.to_s).gsub('\*', '.*?').gsub('\?', '.')}/i)
			end
		}
	end

	def to_dns (name, klass, type)
		DNS::ResourceRecord.new {|rr|
			rr.name  = name
			rr.class = klass
			rr.type  = type
			rr.ttl   = options[:ttl]
		}
	end
end

end; end; end
