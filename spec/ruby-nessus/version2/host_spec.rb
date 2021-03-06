# frozen_string_literal: true

require 'spec_helper'
require 'spec_fixtures/xml'

describe 'Nessus Version 2: Host' do
  before(:all) do
    @xml = RubyNessus::Version2::XML.new(Helpers::DOT_NESSUS_V2)
    @host = @xml.hosts.first
  end

  it 'should parse the host hostname' do
    expect(@host.hostname).to eq 'snorby.org'
  end

  it 'should parse the host start time' do
    expect(@host.start_time).to eq Time.parse('2009-12-11 02:57:52')
  end

  it 'should parse the host stop time' do
    expect(@host.stop_time).to eq Time.parse('2009-12-11 03:25:29')
  end

  it 'should parse the host runtime' do
    expect(@host.runtime).to eq '00 hours 27 minutes and 37 seconds'
  end

  it 'should parse the hosts open ports' do
    expect(@host.open_ports).to eq 37
  end

  it 'should calculate the hosts total event count' do
    expect(@host.total_event_count).to eq 35
  end

  it 'should calculate the hosts total event count with informational events' do
    expect(@host.total_event_count(true)).to eq 47
  end

  it 'should to_s return the ip address' do
    expect(@host.to_s).to eq @host.ip
  end

  it 'should ip return the ip address' do
    expect(@host.ip).to eq '173.45.230.150'
  end

  it 'should mac_addr return nil if the address does not exist' do
    expect(@host.mac_addr).to be_nil
  end

  it 'should os_name return the os name' do
    expect(@host.os_name).to eq 'NetBSD 3.0'
  end

  it 'should tcp_count return the tcp event count' do
    expect(@host.tcp_count).to eq 32
  end

  it 'should udp_count return the udp event count' do
    expect(@host.udp_count).to eq 2
  end

  it 'should icmp_count return the icmp event count' do
    expect(@host.icmp_count).to eq 1
  end

  it 'should not return the netbios name if its not in the example data' do
    expect(@host.netbios_name).to be_nil
  end

  it 'counts events' do
    expect(@host.event_count).to eq 35
  end

  it 'sends the ports' do
    expect(@host.ports).to eq %w[0 123 21 22 25 443 554 7070 80 9090]
  end

  it 'gives the rounded percentage' do
    expect(@host.event_percentage_for('medium', true)).to eq '3'
  end

  it 'gives the percentage' do
    expect(@host.event_percentage_for('medium')).to eq '2.857142857142857'
  end

  it 'raises for wrong levels' do
    expect { @host.event_percentage_for('toto', true) }.to raise_error('Error: toto is not an acceptable severity. Possible options include: all, tdp, udp, icmp, high, medium and low.')
  end
end

describe 'Nessus Version 2: Host severity' do
  before(:all) do
    @xml = RubyNessus::Version2::XML.new(Helpers::DOT_NESSUS_V2)
    @host = @xml.hosts.first
  end

  it 'should calculate the hosts informational event count' do
    expect(@host.informational_severity_count).to eq 12
  end

  it 'should calculate the hosts low severity event count' do
    expect(@host.low_severity_count).to eq 34
  end

  it 'should calculate the hosts medium severity event count' do
    expect(@host.medium_severity_count).to eq 1
  end

  it 'should calculate the hosts high severity event count' do
    expect(@host.high_severity_count).to eq 0
  end

  it 'should calculate the hosts critical severity event count' do
    expect(@host.critical_severity_count).to eq 0
  end

  it 'lists all informational event' do
    @host.informational_severity_events.each do |event|
      expect(event.severity).to eq 0
    end
  end

  it 'lists all low severity events' do
    @host.low_severity_events.each do |event|
      expect(event.severity).to eq 1
    end
  end

  it 'lists all medium severity events' do
    @host.medium_severity_events.each do |event|
      expect(event.severity).to eq 2
    end
  end

  it 'lists all high severity events' do
    @host.high_severity_events.each do |event|
      expect(event.severity).to eq 3
    end
  end

  it 'lists all critical severity events' do
    @host.critical_severity_events.each do |event|
      expect(event.severity).to eq 4
    end
  end
end
