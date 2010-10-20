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

require 'ostruct'
require 'rexml/document'

require 'failnamed/domain'

module DNS

module Named

class Config
  attr_reader :bind, :misc, :forwarding, :domains

  def initialize (path)
    @doc = REXML::Document.new(File.new(path))

    @bind       = OpenStruct.new
    @misc       = OpenStruct.new
    @forwarding = []
    @domains    = []

    @bind.host = (@doc.elements.each('//bind/host') {}.first.text rescue nil)
    @bind.port = (@doc.elements.each('//bind/port') {}.first.text rescue nil)

    @doc.elements.each('//forwarding/server') {|e|
      @forwarding << e.text
    }

    @doc.elements.each('//domains/domain') {|e|
      @domains << Domain.new(e)
    }

    @doc.elements.each('//misc/*') {|e|
      @misc.marshal_load({ e.name => e.text })
    }
  end
end

end

end
