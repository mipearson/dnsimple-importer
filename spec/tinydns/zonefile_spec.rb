require 'spec_helper'
require 'tinydns/zonefile'

describe Tinydns::Zonefile do
  let(:data) do
    %Q(
# A Records
+foo.example.com:1.2.3.4
+foo.example.net:1.2.3.4
+foo.example.org:1.2.3.4:600

# CNAME records
Ccalendar.example.com:ghs.google.com
Ccalendar.example.net:ghs.google.com
Ccalendar.example.org:ghs.google.com:600

# MX records
@example.com::aspmx.l.google.com:10
@example.com::alt1.aspmx.l.google.com:20
@example.com::alt2.aspmx.l.google.com:20:600

# TXT records
'example.com:bing
'example.com:foobarbaz:60

# Other records
:_xmpp-server._tcp.example.com:33:\000\005\000\000\024\225\013xmpp-server\001l\006google\003com\000:86400
)
  end

  context "loading from a string" do
    let(:zone) { Tinydns::Zonefile.load(data, nil) }

    it "has all of the records" do
      zone.records.length.should eq(12)
    end
    it "has the A records" do
      zone.records[0].class.should be(Tinydns::A)
      zone.records[0].name.should eq('foo.example.com')
      zone.records[0].address.should eq('1.2.3.4')
      zone.records[0].ttl.should eq(3600)
      zone.records[1].name.should eq('foo.example.net')
      zone.records[1].address.should eq('1.2.3.4')
      zone.records[1].ttl.should eq(3600)
      zone.records[2].name.should eq('foo.example.org')
      zone.records[2].address.should eq('1.2.3.4')
      zone.records[2].ttl.should eq(600)
    end
    it "has the CNAME records" do
      zone.records[3].class.should be(Tinydns::CNAME)
      zone.records[3].name.should eq('calendar.example.com')
      zone.records[3].domainname.should eq('ghs.google.com')
      zone.records[3].ttl.should eq(3600)
      zone.records[4].name.should eq('calendar.example.net')
      zone.records[4].domainname.should eq('ghs.google.com')
      zone.records[4].ttl.should eq(3600)
      zone.records[5].name.should eq('calendar.example.org')
      zone.records[5].domainname.should eq('ghs.google.com')
      zone.records[5].ttl.should eq(600)
    end
    it "has the MX records" do
      zone.records[6].class.should be(Tinydns::MX)
      zone.records[6].name.should eq('example.com')
      zone.records[6].domainname.should eq('aspmx.l.google.com')
      zone.records[6].priority.should eq("10")
      zone.records[6].ttl.should eq(3600)
      zone.records[7].name.should eq('example.com')
      zone.records[7].domainname.should eq('alt1.aspmx.l.google.com')
      zone.records[7].priority.should eq("20")
      zone.records[7].ttl.should eq(3600)
      zone.records[8].name.should eq('example.com')
      zone.records[8].domainname.should eq('alt2.aspmx.l.google.com')
      zone.records[8].priority.should eq("20")
      zone.records[8].ttl.should eq(600)
    end
    it "has the TXT records" do
      zone.records[9].class.should be(Tinydns::TXT)
      zone.records[9].name.should eq('example.com')
      zone.records[9].data.should eq('bing')
      zone.records[9].ttl.should eq(3600)
      zone.records[10].class.should be(Tinydns::TXT)
      zone.records[10].name.should eq('example.com')
      zone.records[10].data.should eq('foobarbaz')
      zone.records[10].ttl.should eq(60)
    end
    it "has SRV records" do
      zone.records[11].class.should be(Tinydns::SRV)
      zone.records[11].name.should eq('_xmpp-server._tcp.example.com')
      zone.records[11].content.should eq("\x00\x05\x00\x00\x14\x95\vxmpp-server\x01l\x06google\x03com\x00")
      zone.records[11].ttl.should eq(86400)
    end
  end
  
end
