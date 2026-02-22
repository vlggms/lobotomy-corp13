import { map } from 'common/collections';
import { useBackend } from '../backend';
import { Box, Button, NoticeBox, Section, Table } from '../components';
import { Window } from '../layouts';

const getDamageColor = type => {
  switch (type) {
    case 'red':
      return 'red';
    case 'white':
      return 'grey';
    case 'black':
      return 'purple';
    case 'pale':
      return 'blue';
    default:
      return 'label';
  }
};

const getSpeedLabel = speed => {
  if (speed <= 0.39) return 'Very Fast';
  if (speed <= 0.69) return 'Fast';
  if (speed <= 0.99) return 'Normal';
  if (speed <= 1.49) return 'Slow';
  return 'Very Slow';
};

const formatReqs = reqs => {
  if (!reqs) return '-';
  const parts = [];
  if (reqs['Fortitude']) parts.push('F:' + reqs['Fortitude']);
  if (reqs['Prudence']) parts.push('P:' + reqs['Prudence']);
  if (reqs['Temperance']) parts.push('T:' + reqs['Temperance']);
  if (reqs['Justice']) parts.push('J:' + reqs['Justice']);
  return parts.length > 0 ? parts.join(' ') : '-';
};

const formatRangedSpeed = (fireRate, fireDelay) => {
  if (fireRate > 0) {
    return fireRate + ' r/ds';
  }
  if (fireDelay > 0) {
    return fireDelay + ' ds';
  }
  return 'Semi';
};

export const EgoWeaponVend = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Window width={620} height={550}>
      <Window.Content scrollable>
        <Section title="Weapon Storage">
          {data.contents.length === 0 && (
            <NoticeBox>
              This {data.name} is empty.
            </NoticeBox>
          ) || (
            <Table>
              <Table.Row header>
                <Table.Cell>Item</Table.Cell>
                <Table.Cell collapsing textAlign="center">
                  Req
                </Table.Cell>
                <Table.Cell collapsing textAlign="center">
                  Dmg
                </Table.Cell>
                <Table.Cell collapsing textAlign="center">
                  Type
                </Table.Cell>
                <Table.Cell collapsing textAlign="center">
                  Speed
                </Table.Cell>
                <Table.Cell collapsing textAlign="center">
                  Ammo
                </Table.Cell>
                <Table.Cell collapsing />
                <Table.Cell collapsing textAlign="center">
                  Dispense
                </Table.Cell>
              </Table.Row>
              {map((value, key) => (
                <Table.Row key={key}>
                  <Table.Cell color={value.can_use ? 'green' : 'red'}>
                    {value.name}
                    {!!value.is_ranged && (
                      <Box inline color="label" ml={1}>
                        [Ranged]
                      </Box>
                    )}
                  </Table.Cell>
                  <Table.Cell collapsing textAlign="center">
                    {formatReqs(value.requirements)}
                  </Table.Cell>
                  <Table.Cell collapsing textAlign="center">
                    {value.damage}
                  </Table.Cell>
                  <Table.Cell
                    collapsing
                    textAlign="center"
                    color={getDamageColor(value.damtype)}>
                    {value.damtype?.toUpperCase()}
                  </Table.Cell>
                  <Table.Cell collapsing textAlign="center">
                    {value.is_ranged
                      ? formatRangedSpeed(value.fire_rate, value.fire_delay)
                      : getSpeedLabel(value.speed)}
                  </Table.Cell>
                  <Table.Cell collapsing textAlign="center">
                    {value.is_ranged && value.needs_reload
                      ? value.max_ammo
                      : '-'}
                  </Table.Cell>
                  <Table.Cell collapsing textAlign="right">
                    x{value.amount}
                  </Table.Cell>
                  <Table.Cell collapsing>
                    <Button
                      content="One"
                      disabled={value.amount < 1}
                      onClick={() => act('Release', {
                        name: value.name,
                        amount: 1,
                      })}
                    />
                    <Button
                      content="Many"
                      disabled={value.amount <= 1}
                      onClick={() => act('Release', {
                        name: value.name,
                      })}
                    />
                  </Table.Cell>
                </Table.Row>
              ))(data.contents)}
            </Table>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
