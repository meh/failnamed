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

module DNS

module Named

class Cacheable
  attr_accessor :value, :ttl

  def initialize (value, ttl)
    @modified = Time.now

    @value = value
    @ttl   = ttl
  end

  def valid?
    (@modified.to_i + @ttl) > Time.now.to_i
  end
  
  def inspect
    "#<Cacheable:(#{@ttl}) #{@value.inspect}>"
  end
end

end

end
