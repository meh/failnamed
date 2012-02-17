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

module DNS; class Named

class Zones < Hash
	def initialize (*)
		super

		@cache = Cache.new(self)
	end

	def zone (name, &block)
		name.downcase!

		if self[name]
			warn "a zone named #{name} already exists, overwriting"
		end

		self[name] = Zone.new(name, &block)
	end

	def answer (question, message, response)
		response.questions << question

		unless (Zones.const_get(question.class).const_get(question.type) rescue false)
			response.header = DNS::Header.new {|h|
				h.id = message.header.id

				h.type  = :RESPONSE
				h.class = :QUERY

				h.status = :NOTIMP
			}

			throw :return
		end

		if (record = @cache[question.class, question.type, question.name]).valid?
			return record
		end

		record = nil

		each_value {|zone|

		}

		return record if record.nil?

		@cache[question.class, question.type, question.name] = record
	end
end

end; end
