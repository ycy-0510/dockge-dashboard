part of '../views/dashboard_page.dart';

class NetworkTopologyView extends ConsumerWidget {
  const NetworkTopologyView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topology = ref.watch(networkTopologyViewModelProvider);
    return CustomScrollView(
      slivers: [
        PortList(ports: topology.ports),
        ExternalNetworkList(networks: topology.externalNetworks),
        SliverToBoxAdapter(
          child: SizedBox(height: MediaQuery.of(context).padding.bottom),
        ),
      ],
    );
  }
}

class PortList extends StatelessWidget {
  const PortList({super.key, required this.ports});
  final List<PublishedPort> ports;

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 5),
            child: Text(
              'Ports',
              style: context.theme.typography.display.xs.copyWith(
                color: context.theme.colors.mutedForeground,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: ports.isEmpty
              ? FTile(title: const Text('No published ports found'))
              : FTileGroup.builder(
                  count: ports.length,
                  tileBuilder: (context, idx) => FTile(
                    prefix: SizedBox(
                      width: 50,
                      child: Text('${ports[idx].port ?? 'NA'}'),
                    ),
                    title: Wrap(
                      spacing: 5,
                      children: [
                        Text(ports[idx].stackName),
                        Icon(FLucideIcons.chevronRight),
                        Text(ports[idx].serviceName),
                      ],
                    ),
                    subtitle: Text(_portServiceName(ports[idx].port)),
                  ),
                ),
        ),
      ],
    );
  }
}

String _portServiceName(int? port) => switch (port) {
  null => 'Dynamic host port',
  20 => 'FTP data',
  21 => 'FTP',
  22 => 'SSH',
  23 => 'Telnet',
  25 => 'SMTP',
  53 => 'DNS',
  67 => 'DHCP server',
  68 => 'DHCP client',
  69 => 'TFTP',
  80 => 'HTTP',
  110 => 'POP3',
  123 => 'NTP',
  143 => 'IMAP',
  161 => 'SNMP',
  162 => 'SNMP trap',
  389 => 'LDAP',
  443 => 'HTTPS',
  445 => 'SMB',
  465 => 'SMTPS',
  514 => 'Syslog',
  587 => 'SMTP submission',
  636 => 'LDAPS',
  853 => 'DNS over TLS',
  993 => 'IMAPS',
  995 => 'POP3S',
  1883 => 'MQTT',
  3306 => 'MySQL',
  3389 => 'RDP',
  5432 => 'PostgreSQL',
  5672 => 'AMQP',
  6379 => 'Redis',
  8080 => 'HTTP alternate',
  8443 => 'HTTPS alternate',
  9092 => 'Kafka',
  27017 => 'MongoDB',
  _ => 'Custom service',
};

class ExternalNetworkList extends StatelessWidget {
  const ExternalNetworkList({super.key, required this.networks});

  final List<ExternalNetwork> networks;
  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 5),
            child: Text(
              'Global Network',
              style: context.theme.typography.display.xs.copyWith(
                color: context.theme.colors.mutedForeground,
              ),
            ),
          ),
        ),
        if (networks.isEmpty)
          SliverToBoxAdapter(
            child: FTile(title: const Text('No shared networks found')),
          ),
        for (final network in networks)
          SliverMainAxisGroup(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 2),
                  child: Text(network.name),
                ),
              ),
              SliverList.separated(
                itemCount: network.members.length,
                itemBuilder: (context, idx) {
                  return Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: FTile(title: Text(network.members[idx])),
                      ),
                      Positioned(
                        left: 0,
                        top: 0,
                        bottom: 0,
                        width: 22,
                        child: _TreeBranch(
                          color: context.theme.colors.border,
                          isLast: idx == network.members.length - 1,
                        ),
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) => SizedBox(
                  width: 22,
                  height: 10,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: 2,
                      height: double.infinity,
                      child: ColoredBox(color: context.theme.colors.border),
                    ),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _TreeBranch extends StatelessWidget {
  const _TreeBranch({required this.color, required this.isLast});

  final Color color;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: FractionallySizedBox(
            heightFactor: isLast ? 0.5 : 1,
            child: SizedBox(width: 2, child: ColoredBox(color: color)),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            width: double.infinity,
            height: 2,
            child: ColoredBox(color: color),
          ),
        ),
      ],
    );
  }
}
