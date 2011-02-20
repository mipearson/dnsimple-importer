module Dnsimple
  class ZoneImporter
    def import(f)
      puts "importing from '#{f}'"
      #_import_1(f)
      import_from_string(IO.read(f))
    end
    def import_from_string(s)
      require 'dns/zonefile'
      zone = DNS::Zonefile.load(s)
      zone.records.each do |r|
        case r
          when DNS::A then
            puts "A record: #{r.host} -> #{r.address} (ttl: #{r.ttl})"
          when DNS::AAAA then
            puts "AAAA record: #{r.host} -> #{r.address} (ttl: #{r.ttl})"
          when DNS::CNAME then
            puts "CNAME record: #{r.host} -> #{r.domainname} (ttl: #{r.ttl})"
          when DNS::NS then
            puts "NS record: #{r.host} -> #{r.domainname} (ttl: #{r.ttl})"
          when DNS::PTR then
            puts "PTR record: #{r.host} -> #{r.domainname} (ttl: #{r.ttl})"
          when DNS::MX then
            puts "MX record: #{r.host} -> #{r.domainname} (prio: #{r.priority}, ttl: #{r.ttl})"
          when DNS::TXT then
            puts "TXT record: #{r.host} -> #{r.data} (ttl: #{r.ttl})"
          when DNS::SRV then
            puts "SRV record: #{r.host} -> #{r.domainname} (prio: #{r.priority}, weight: #{r.weight}, port: #{r.port}, ttl: #{r.ttl})"
          when DNS::NAPTR then
            puts "NAPTR record: #{r.host} -> #{t.data} (ttl: #{r.ttl})"
        end
      end
    end
  end
end
