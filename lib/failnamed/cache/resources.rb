#--
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
#++

require 'failnamed/cacheable'

module DNS

module Named

class Cache

class Resources
  attr_reader :name

  def initialize (name)
    @name = name.to_sym

    @new       = true
    @resources = []
  end

  def << (resource)
    old!

    @resources << Cacheable.new(resource, resource.ttl)
  end

  def valid?
    return false if @new

    @resources.all? {|c|
      c.valid?
    }
  end

  def data
    @resources.map {|c|
      Cacheable.new(c.value.data, c.ttl)
    }
  end

  def old!
    @new = false
  end
end

end

end

end
