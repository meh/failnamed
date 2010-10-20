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

require 'failnamed/cache/resources'

module DNS

module Named

class Cache

class Domain
  attr_accessor :ttl

  attr_reader :name

  def initialize (name, ttl=3600)
    @name = name
    @ttl  = ttl

    @records = {}

    self.not_exists!
    @modified = Time.now - ttl * 2
  end

  def update (resource)
    (@records[resource.type.to_sym] ||= Resources.new(name)) << resource

    resource
  end

  def data (name)
    (@records[name.to_sym] ||= Resources.new(name)).data
  end

  def clear (name)
    tmp = @records[name]

    @records[name] = Resources.new(name)

    tmp
  end

  def checked! (name)
    @records[name].old!
  end

  def valid? (name=nil)
    if name
      (@records[name] ||= Resources.new(name)).valid?
    else
      (@modified.to_i + @ttl) > Time.now.to_i
    end
  end

  def exists?;     @exists                               end
  def exists!;     @exists = true;  @modified = Time.now end
  def not_exists!; @exists = false; @modified = Time.now end
end

end

end

end
