import { sortBy } from 'common/collections';
import { flow } from 'common/fp';
import { useBackend, useLocalState } from '../backend';
import { Box, Button, LabeledList, Section, Stack } from '../components';
import { Window } from '../layouts';
import { capitalize } from 'common/string';

export const LC13AbnormalityArchive = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    abnormality_info,
  } = data;

  const abnormality_by_name = flow([
    sortBy(abnormality_info => abnormality_info.name),
  ])(data.abnormality_info || []);

  const [
    current_abnormality,
    setcurrent_abnormality,
  ] = useLocalState(context, 'current_abnormality', null);
  return (
    <Window
      width={800}
      height={600}>
      <Window.Content>
        <Stack fill>
          <Stack.Item width="150px">
            <Section fill scrollable>
              {abnormality_by_name.map(f => (
                <Button
                  key={f.name}
                  fluid
                  color="transparent"
                  selected={f === current_abnormality}
                  onClick={() => { setcurrent_abnormality(f); }}>
                  {f.name}
                </Button>
              ))}
            </Section>
          </Stack.Item>
          <Stack.Item grow basis={0}>
            <Section
              fill
              scrollable
              title={current_abnormality
                ? capitalize(current_abnormality.name)
                : " Lobotomy Corporation Archive"}>
              {current_abnormality && (
                <LabeledList>
                  <LabeledList.Item label="File Info">
                    {current_abnormality.name}
                  </LabeledList.Item>
                  <LabeledList.Item>
                    <Linesoftext subject={current_abnormality} />
                  </LabeledList.Item>
                  <LabeledList.Item>
                    <Button.Confirm
                      fluid
                      icon="check"
                      color="red"
                      textAlign="center"
                      content="Print File"
                      onClick={() => act('print_file', { ref: current_abnormality.type })} />
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

// Theres a tower on this island.
const Linesoftext = (props, context) => {
  const { subject } = props;
  const the_tower = []; // The bottom of the_tower
  if (!subject) {
    return (
      <Section>
        {"ERROR NO FILE subject"}
      </Section>
    );
  }
  if (!subject.linecount) {
    return (
      <Section>
        {"ERROR NO READABLE FILE TEXT"}
      </Section>
    );
  }
  for (let index = 0; index <= subject.linecount; index++) {
    const Tower_element = ( // Produce Tower_element
      <Towergear 
        tower_subject={subject} 
        line_place={index} 
      /> // Tower_Gear is on the Next Island. 
      // It produces Tower_element based on the values put inside it.
    );
    the_tower.push(Tower_element); // Add Tower_element to the_tower
  }
  return ( // Return the_tower code.
    [the_tower]
  );
};

// Towergear does not work unless it has capitalization. 
// Apparently all consts must be in pascaltext
const Towergear = (props, context) => { 
  const { tower_subject, line_place } = props;
  let tower_gear_sound = "line" + [line_place]; 
  // Coding this has the feeling of being lost 
  // with only fickle candles to light the way.
  if (!tower_subject[tower_gear_sound]) { 
    // The value is empty even though the max size of the list counts it.
    return (
      <Box>
        {" "}
      </Box>
    );
  }
  return ( // Return code below to the tower.
    <Box>
      {tower_subject[tower_gear_sound]}
    </Box>
  );
};
// It turns out in the end tower_subject[tower_gear_sound] 
// is the same as tower_subject.tower_gear_sound.
