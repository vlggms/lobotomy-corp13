// THIS IS A LOBOTOMYCORPORATION UI FILE

import { useBackend } from '../backend';
import { Box, Button, Collapsible, ProgressBar, AnimatedNumber, Section, LabeledList } from '../components';
import { Window } from '../layouts';

export const SephirahPanel = (props, context) => {
  return (
    <Window title="Sephirah game control panel" width="1000" height="550">
      <Window.Content>
        <AbnoInfo />
        <ButtonPanel />
      </Window.Content>
    </Window>
  );
};

const AbnoInfo = (props, context) => {
  const { data } = useBackend(context);
  const {
    abno_number,
    queued_abno,
    previous_arrival_time,
    current_arrival_time,
    next_arrival_time,
  } = data;

  return (
    <Section title="Master Facility Information">
      <LabeledList>
        <LabeledList.Item label="Current number of abnormalities: ">
          {abno_number}
        </LabeledList.Item>
        <LabeledList.Item label="Currently queued abnormality: ">
          {queued_abno}
        </LabeledList.Item>
        <LabeledList.Item label="Time until next abnormality arrival">
          <ProgressBar
            value={current_arrival_time}
            minValue={previous_arrival_time}
            maxValue={next_arrival_time}
          >
            <AnimatedNumber
              value={(next_arrival_time - current_arrival_time) / 10 + " seconds"}
            />
          </ProgressBar>
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

const ButtonPanel = (props, context) => {
  const { act, data } = useBackend(context);
  const { abnormality_arrival, meltdown_speed } = data;

  return (
    <Section title="Available actions">
      <Box mt="0.5em">
        <Collapsible title="Complete quest">
          <LabeledList.Item
            labelWrap
            label="Reward the facility for completing a custom quest that you set out earlier this shift."
            buttons={
              <Button
                content={'Complete quest'}
                color={'green'}
                onClick={() => act('Complete quest')}
              />
            }
          />
        </Collapsible>
        <Collapsible title="Make announcement">
          <LabeledList.Item
            labelWrap
            label="Allows you to make a global announcement."
            buttons={
              <Button
                content={'Make announcement'}
                color={'green'}
                onClick={() => act('Make announcement')}
              />
            }
          />
        </Collapsible>
        <Collapsible title="Randomize abnormality">
          <LabeledList.Item
            labelWrap
            label="Randomizes the current abnormality, only works if the abnormality has not yet been randomized at its current state. Gives the manager 1 LOB."
            buttons={
              <Button
                content={'Randomize abnormality'}
                color={'green'}
                onClick={() => act('Randomize abnormality')}
              />
            }
          />
        </Collapsible>
        <Collapsible title="Randomize selection">
          <LabeledList.Item
            labelWrap
            label="Randomizes the current abnormality selection. Gives the manager 1 LOB."
            buttons={
              <Button
                content={'RRandomize selection'}
                color={'green'}
                onClick={() => act('Randomize selection')}
              />
            }
          />
        </Collapsible>
        <Collapsible title="Manipulate abnormality arrival time">
          <LabeledList.Item>
            <ProgressBar
              minValue={-3}
              maxValue={3}
              value={abnormality_arrival}>
              <AnimatedNumber value={abnormality_arrival} />
            </ProgressBar>
          </LabeledList.Item>
          <LabeledList.Item
            labelWrap
            label="Makes all abnormalities arrive 20% quicker (multiplicativelly)"
            buttons={
              <Button
                content={abnormality_arrival < 3 ? 'Quicken abnormality arrival' : 'Speed at maximum!'}
                color={abnormality_arrival < 3 ? 'green' : 'red'}
                onClick={() => act('Quicken abnormality arrival')}
              />
            }
          />
          <LabeledList.Item
            labelWrap
            label="Makes all abnormalities arrive 20% slower (multiplicativelly)"
            buttons={
              <Button
                content={abnormality_arrival > -3 ? 'Slow abnormality arrival': 'Speed at minimum!'}
                color={abnormality_arrival > -3 ? 'green' : 'red'}
                onClick={() => act('Slow abnormality arrival')}
              />
            }
          />
        </Collapsible>
        <Collapsible title="Manipulate Work per Meltdown ratio">
          <LabeledList.Item>
            <ProgressBar
              minValue={-4}
              maxValue={6}
              value={meltdown_speed}>
              <AnimatedNumber value={meltdown_speed} />
            </ProgressBar>
          </LabeledList.Item>
          <LabeledList.Item
            labelWrap
            label="All meltdowns will take one more work before accuring"
            buttons={
              <Button
                content={meltdown_speed < 6 ? 'Increase Work per Meltdown ratio': 'Additional meltdown works at maximum!'}
                color={meltdown_speed < 6 ? 'green' : 'red'}
                onClick={() => act('Increase Work per Meltdown ratio')}
              />
            }
          />
          <LabeledList.Item
            labelWrap
            label="All meltdowns will take one less work before accuring"
            buttons={
              <Button
                content={meltdown_speed > -4 ? 'Decrease Work per Meltdown ratio': 'Additional meltdown works at minimum!'}
                color={meltdown_speed > -4 ? 'green' : 'red'}
                onClick={() => act('Decrease Work per Meltdown ratio')}
              />
            }
          />
        </Collapsible>
        <Collapsible title="Manipulate Abnormalities melting down per meltdown">
          <LabeledList.Item
            labelWrap
            label="One more abnormality will melt per event"
            buttons={
              <Button
                content={'Increase abnormality per meltdown ratio'}
                color={'green'}
                onClick={() => act('Increase abnormality per meltdown ratio')}
              />
            }
          />
          <LabeledList.Item
            labelWrap
            label="One less abnormality will melt per event"
            buttons={
              <Button
                content={'Decrease abnormality per meltdown'}
                color={'green'}
                onClick={() => act('Decrease abnormality per meltdown')}
              />
            }
          />
        </Collapsible>
        <Collapsible title="Authorize execution bullets">
          <LabeledList.Item
            labelWrap
            label="Put your vote in to authorize execution bullets for the manager. 2 Sephirah have to agree for this to pass."
            buttons={
              <Button
                content={'Authorize execution bullets'}
                color={'red'}
                onClick={() => act('Authorize execution bullets')}
              />
            }
          />
        </Collapsible>
      </Box>
    </Section>
  );
};
