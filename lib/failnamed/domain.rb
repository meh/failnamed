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

require 'faildns/ip'
require 'faildns/domainname'

require 'failnamed/domain/match'

module DNS

module Named

class Domain
  attr_reader :name, :ttl, :matches, :ips, :addresses, :mails, :nameservers

  def initialize (dom)
    @name = dom.attributes['name']
    @ttl  = dom.attributes['ttl'] || 3600

    @matches     = []
    @ips         = []
    @addresses   = []
    @mails       = []
    @nameservers = []

    dom.elements.each {|e|
      case e.name
        when 'matches'
          @matches << Match.new(e.attributes['type'] || 'wildcard', e.text)

        when 'ip'
          @ips << DNS::IP.new(e.text)

        when 'address'
          @addresses << DNS::DomainName.new(e.text)

        when 'mail'
          @mails << DNS::DomainName.new(e.text)
        
        when 'nameserver'
          @nameservers << DNS::DomainName.new(e.text)
      end
    }

    if block_given?
      yield self
    end
  end

  def match (domain)
    @matches.any? {|match|
      match.test(domain)
    }
  end

  def inspect
    "#<Domain:(#{@name} [#{@ttl}]) #{@ips.concat(@addresses).join(' ')}>"
  end
end

end

end
