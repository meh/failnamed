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

module DNS; class Named; class Zones < Hash; class IN

class A < Record
	def initialize (zone, what, options = {}, &block)
		super(zone, { ttl: 3600 }.merge(options), &block)

		@what = what
	end

	def to_dns (name)
		super(name, :IN, :A).tap {|rr|
			rr.data = if DNS::IP.valid?(@what)
				DNS::ResourceRecord::IN::A.new(@what)
			else
				return unless ip = zone.client.resolve(@what).first

				DNS::ResourceRecord::IN::A.new(ip)
			end
		}
	end
end

end; end; end; end
