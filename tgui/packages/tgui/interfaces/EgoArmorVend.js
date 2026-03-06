import { map } from 'common/collections';
import { useBackend } from '../backend';
import { Button, NoticeBox, Section, Table } from '../components';
import { Window } from '../layouts';

const getResistColor = value => {
  if (value >= 50) return 'green';
  if (value >= 20) return 'olive';
  if (value >= 0) return 'label';
  return 'red';
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

export const EgoArmorVend = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Window width={600} height={550}>
      <Window.Content scrollable>
        <Section title="Armor Storage">
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
                <Table.Cell collapsing textAlign="center" color="red">
                  R
                </Table.Cell>
                <Table.Cell collapsing textAlign="center" color="grey">
                  W
                </Table.Cell>
                <Table.Cell collapsing textAlign="center" color="purple">
                  B
                </Table.Cell>
                <Table.Cell collapsing textAlign="center" color="blue">
                  P
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
                  </Table.Cell>
                  <Table.Cell collapsing textAlign="center">
                    {formatReqs(value.requirements)}
                  </Table.Cell>
                  <Table.Cell
                    collapsing
                    textAlign="center"
                    color={getResistColor(value.resistances?.red)}>
                    {value.resistances?.red ?? 1}
                  </Table.Cell>
                  <Table.Cell
                    collapsing
                    textAlign="center"
                    color={getResistColor(value.resistances?.white)}>
                    {value.resistances?.white ?? 1}
                  </Table.Cell>
                  <Table.Cell
                    collapsing
                    textAlign="center"
                    color={getResistColor(value.resistances?.black)}>
                    {value.resistances?.black ?? 1}
                  </Table.Cell>
                  <Table.Cell
                    collapsing
                    textAlign="center"
                    color={getResistColor(value.resistances?.pale)}>
                    {value.resistances?.pale ?? 1}
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
