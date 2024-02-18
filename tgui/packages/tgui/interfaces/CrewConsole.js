import { sortBy } from 'common/collections';
import { useBackend } from '../backend';
import { Box, Button, ColorBox, Section, Table } from '../components';
import { COLORS } from '../constants';
import { Window } from '../layouts';

const HEALTH_COLOR_BY_LEVEL = [
  '#1bee6c',
  '#7ed014',
  '#a8b000',
  '#c48b00',
  '#d55f00',
  '#db1f0a',
];

const SANITY_COLOR_BY_LEVEL = [
  '#97f7f7',
  '#75c8ce',
  '#559ba5',
  '#39707c',
  '#1e4854',
  '#05242e',
];

const jobIsHead = jobId => jobId % 10 === 0;

const jobToColor = jobId => {
  if (jobId === 0) {
    return COLORS.department.captain;
  }
  if (jobId >= 10 && jobId < 20) {
    return COLORS.department.security;
  }
  if (jobId >= 20 && jobId < 30) {
    return COLORS.department.medbay;
  }
  if (jobId >= 30 && jobId < 40) {
    return COLORS.department.science;
  }
  if (jobId >= 40 && jobId < 50) {
    return COLORS.department.engineering;
  }
  if (jobId >= 50 && jobId < 60) {
    return COLORS.department.cargo;
  }
  if (jobId >= 150 && jobId < 159) {
    return COLORS.department.head;
  }
  if (jobId >= 160 && jobId < 200) {
    return COLORS.department.syndicate;
  }
  if (jobId >= 200 && jobId < 230) {
    return COLORS.department.centcom;
  }
  return COLORS.department.other;
};

const healthToColor = (oxy, tox, burn, brute, maxhp) => {
  const healthSum = oxy + tox + burn + brute;
  const healthQuarter = maxhp / 4;
  const level = Math.min(Math.max(Math.ceil(healthSum / healthQuarter), 0), 5);
  return HEALTH_COLOR_BY_LEVEL[level];
};

const sanityToColor = (san, maxsp) => {
  const sanityQuarter = maxsp / 4;
  const level = Math.min(Math.max(Math.ceil(san / sanityQuarter), 0), 5);
  return SANITY_COLOR_BY_LEVEL[level];
};

const HealthStat = props => {
  const { type, value } = props;
  return (
    <Box
      inline
      width={2}
      color={COLORS.damageType[type]}
      textAlign="center">
      {value}
    </Box>
  );
};

export const CrewConsole = () => {
  return (
    <Window
      title="Crew Monitor"
      width={600}
      height={600}>
      <Window.Content scrollable>
        <Section minHeight="540px">
          <CrewTable />
        </Section>
      </Window.Content>
    </Window>
  );
};

const CrewTable = (props, context) => {
  const { act, data } = useBackend(context);
  const sensors = sortBy(
    s => s.ijob
  )(data.sensors ?? []);
  return (
    <Table>
      <Table.Row>
        <Table.Cell bold>
          Name
        </Table.Cell>
        <Table.Cell bold collapsing />
        <Table.Cell bold collapsing />
        <Table.Cell bold collapsing textAlign="center">
          Vitals
        </Table.Cell>
        <Table.Cell bold>
          Position
        </Table.Cell>
        {!!data.link_allowed && (
          <Table.Cell bold collapsing>
            Tracking
          </Table.Cell>
        )}
      </Table.Row>
      {sensors.map(sensor => (
        <CrewTableEntry sensor_data={sensor} key={sensor.ref} />
      ))}
    </Table>
  );
};

const CrewTableEntry = (props, context) => {
  const { act, data } = useBackend(context);
  const { link_allowed } = data;
  const { sensor_data } = props;
  const {
    name,
    assignment,
    ijob,
    life_status,
    oxydam,
    toxdam,
    burndam,
    brutedam,
    sandam,
    maxhp,
    maxsp,
    area,
    can_track,
  } = sensor_data;

  return (
    <Table.Row>
      <Table.Cell
        bold={jobIsHead(ijob)}
        color={jobToColor(ijob)}>
        {name}{assignment !== undefined ? ` (${assignment})` : ""}
      </Table.Cell>
      <Table.Cell collapsing textAlign="center">
        <ColorBox
          color={healthToColor(
            oxydam,
            toxdam,
            burndam,
            brutedam,
            maxhp)} />
      </Table.Cell>
      <Table.Cell collapsing textAlign="center">
        <ColorBox
          color={sanityToColor(
            sandam,
            maxsp)} />
      </Table.Cell>
      <Table.Cell collapsing textAlign="center">
        {oxydam !== undefined ? (
          <Box inline>
            <HealthStat type="brute" value={brutedam} />
            {'/'}
            <HealthStat type="sanity" value={sandam} />
            {'/'}
            <HealthStat type="oxy" value={oxydam} />
            {'/'}
            <HealthStat type="toxin" value={toxdam} />
            {'/'}
            <HealthStat type="burn" value={burndam} />
          </Box>
        ) : (
          life_status ? 'Alive' : 'Dead'
        )}
      </Table.Cell>
      <Table.Cell>
        {area !== undefined ? area : 'N/A'}
      </Table.Cell>
      {!!link_allowed && (
        <Table.Cell collapsing>
          <Button
            content="Track"
            disabled={!can_track}
            onClick={() => act('select_person', {
              name: name,
            })} />
        </Table.Cell>
      )}
    </Table.Row>
  );
};
