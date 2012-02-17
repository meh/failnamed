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

require 'failnamed/zones/matchable'

require 'failnamed/zones/IN'

module DNS; class Named; class Zones < Hash

class Zone < Hash
	def initialize (&block)
		default_proc = proc { |h, k| h[k] = [] }
	end

	def IN (&block)
		IN.new(self, &block)
	end

	alias internet IN
	alias net      IN

	Zones::IN.constants.each {|name|
		define_method name do |*args, &block|
			self[name] << Zone.const_get(name).new(*args, &block)
		end
	}

	def ip (version = 4, what, &block)
		if version == 4
			A(what, &block)
		elsif version == 6
			AAAA(what, &block)
		end
	end
end

end; end; end
