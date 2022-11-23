import { sortBy } from 'common/collections';
import { flow } from 'common/fp';
import { classes } from 'common/react';
import { useBackend, useLocalState } from '../backend';
import { Box, Button, LabeledList, Section, Stack } from '../components';
import { Window } from '../layouts';
import { capitalize } from 'common/string';

export const LC13ItemCatalog = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    lc13_tool_info,
  } = data;
  const item_by_name = flow([
    sortBy(item => item.name),
  ])(data.lc13_tool_info || []);
  const [
    currentitem,
    setCurrentitem,
  ] = useLocalState(context, 'currentitem', null);
  return (
    <Window
      width={800}
      height={300}>
      <Window.Content>
        <Stack fill>
          <Stack.Item width="190px">
            <Section fill scrollable>
              {item_by_name.map(f => (
                <Button
                  key={f.class_code}
                  fluid
                  color="transparent"
                  selected={f === currentitem}
                  onClick={() => { setCurrentitem(f); }}>
                  {f.class_code}
                </Button>
              ))}
            </Section>
          </Stack.Item>
          <Stack.Item grow basis={0}>
            <Section
              fill
              scrollable
              title={currentitem
                ? capitalize(currentitem.class_code)
                : "Item Index"}>
              {currentitem && (
                <LabeledList>
                  <LabeledList.Item label="Name">
                    {currentitem.name}
                  </LabeledList.Item>
                  <LabeledList.Item label="Description">
                    {currentitem.desc}
                  </LabeledList.Item>
                  <LabeledList.Item label="Risk Level">
                    {currentitem.risk_level}
                  </LabeledList.Item>
                  <LabeledList.Item label="Illustration">
                    <Box
                      className={classes([
                        'lc13_tool32x32',
                        currentitem.icon,
                      ])} />
                  </LabeledList.Item>
                </LabeledList>
              )}
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
