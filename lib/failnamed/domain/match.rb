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

class Domain

class Match
  attr_reader :type, :match, :regexp

  def initialize (type, match)
    @type  = type
    @match = match

    case @type
      when 'regexp'
        @regexp = Regexp.new(@match)

      when 'wildcard'
        @regexp = Regexp.new('^' + Regexp.escape(@match).gsub(/\\\*/, '.*').gsub(/\\\?/, '.') + '$')

      else
        @regexp = Regexp.new ''
    end
  end

  def test (domain)
    !!domain.to_s.match(@regexp)
  end
end

end

end

end
