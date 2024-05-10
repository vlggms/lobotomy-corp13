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
    minimum_arrival,
    current_arrival,
    next_arrival,
    maximum_arrival,
    progress_component,
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
        {/*
        <LabeledList.Item label="Current abnormality arrival time">
          <ProgressBar
            value={progress_component}>
            <AnimatedNumber
              value={current_arrival / 10
              + ' seconds, (estimated next arrival: '
              + next_arrival / 10
              + ' seconds)'}
            />
          </ProgressBar>
        </LabeledList.Item>
        */}
      </LabeledList>
    </Section>
  );
};

const ButtonPanel = (props, context) => {
  const { act, data } = useBackend(context);
  const { abnormality_arrival, meltdown_speed } = data;

  return (
    <Section title="Avaible actions">
      <Box mt="0.5em">
        <LabeledList>
          <Collapsible title="Randomize abnormality">
            <LabeledList.Item
              labelWrap
              label="Randomizes the current abnormality, only works if the abnormality has not yet been randomized at its current state"
              buttons={
                <Button
                  content={'Randomize abnormality'}
                  color={'green'}
                  onClick={() => act('Randomize abnormality')}
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
        </LabeledList>
      </Box>
    </Section>
  );
};
