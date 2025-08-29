import { useBackend, useLocalState } from '../backend';
import { filter, sortBy } from 'common/collections';
import { createSearch } from 'common/string';
import { flow } from 'common/fp';
import { Button, Collapsible, LabeledList, Input, Section, Table } from '../components';
import { Window } from '../layouts';
import { LabeledListItem } from '../components/LabeledList';

export const chemSearch = (chems, searchText = '') => {
  const testSearch = createSearch(searchText, chemical => chemical.name);
  return flow([
    filter(chemical => chemical?.name),
    searchText && filter(testSearch),
    sortBy(chemical => chemical.name),
  ])(chems);
};

export const reactionSearch = (reactions, searchText = '') => {
  const testSearch = createSearch(searchText, reaction => reaction.title);
  return flow([
    filter(reaction => reaction?.title),
    searchText && filter(testSearch),
    sortBy(reaction => reaction.title),
  ])(reactions);
};

export const ReagentList = (props, context) => {
  const { act, data } = useBackend(context);
  const [
    searchText,
    setSearchText,
  ] = useLocalState(context, 'searchText', '');
  const [
    screen,
    setScreen,
  ] = useLocalState(context, 'screen', "reagent_screen");

  const chems = chemSearch(data.chems, searchText);
  const reactions = reactionSearch(data.reactions, searchText);

  return (
    <Window
      width={465}
      height={550}>
      <Window.Content scrollable>
        {screen === "reaction_screen" && (
          <Section
            title="Reactions"
            buttons={(
              <>
                Search
                <Input
                  autoFocus
                  value={searchText}
                  onInput={(e, value) => setSearchText(value)}
                  mx={1} />
                <Button
                  icon="exchange-alt"
                  content="Reagents"
                  onClick={() => setScreen("reagent_screen")} />
              </>
            )}>
            <ReactionTable>
              {reactions.map(reaction => (
                <ReactionRecipe
                  key={reaction.id}
                  reaction={reaction}
                />
              ))}
            </ReactionTable>
          </Section>) || (
          <Section
            title="Reagents"
            buttons={(
              <>
                Search
                <Input
                  autoFocus
                  value={searchText}
                  onInput={(e, value) => setSearchText(value)}
                  mx={1} />
                <Button
                  icon="exchange-alt"
                  content="Reactions"
                  onClick={() => setScreen("reaction_screen")} />
              </>
            )}>
            <ChemTable>
              {chems.map(chemical => (
                <ChemStats
                  key={chemical.id}
                  chemical={chemical}
                />
              ))}
            </ChemTable>
          </Section>)}
      </Window.Content>
    </Window>
  );
};

const ChemTable = Table;

const ChemStats = (props, context) => {
  const { chemical } = props;
  return (
    <Table.Row key={chemical.id}>
      <Collapsible
        title={chemical.name}
      >
        <LabeledList>
          {chemical.desc !== "" && (
            <LabeledList.Item label="Description">
              {chemical.desc}
            </LabeledList.Item>
          )}
          {chemical.other !== "N/A" && (
            <LabeledList.Item label="Extra Information">
              {chemical.other.map(strings => (
                <span key={strings}>{strings}</span>
              ))}
            </LabeledList.Item>
          )}
          <LabeledList.Item label="Metabolization Rate">
            {chemical.metab} u/second
          </LabeledList.Item>
          {chemical.health !== 0 && (
            <LabeledList.Item label="Health Effect">
              {chemical.health}%/unit
            </LabeledList.Item>
          )}
          {chemical.sanity !== 0 && (
            <LabeledList.Item label="Sanity Effect">
              {chemical.sanity}%/unit
            </LabeledList.Item>
          )}
          {chemical.fort !== "+0" && (
            <LabeledList.Item label="Fortitude">
              {chemical.fort}
            </LabeledList.Item>
          )}
          {chemical.prud !== "+0" && (
            <LabeledList.Item label="Prudence">
              {chemical.prud}
            </LabeledList.Item>
          )}
          {chemical.temp !== "+0" && (
            <LabeledList.Item label="Temperance">
              {chemical.temp}
            </LabeledList.Item>
          )}
          {chemical.just !== "+0" && (
            <LabeledList.Item label="Justice">
              {chemical.just}
            </LabeledList.Item>
          )}
          {chemical.red !== 0 && (
            <LabeledList.Item label="Red Armor">
              {chemical.red}
            </LabeledList.Item>
          )}
          {chemical.whi !== 0 && (
            <LabeledList.Item label="White Armor">
              {chemical.whi}
            </LabeledList.Item>
          )}
          {chemical.bla !== 0 && (
            <LabeledList.Item label="Black Armor">
              {chemical.bla}
            </LabeledList.Item>
          )}
          {chemical.pal !== 0 && (
            <LabeledList.Item label="Pale Armor">
              {chemical.pal}
            </LabeledList.Item>
          )}
          {chemical.red_d !== 1 && (
            <LabeledList.Item label="Incoming Red Damage">
              x{chemical.red_d}
            </LabeledList.Item>
          )}
          {chemical.whi_d !== 1 && (
            <LabeledList.Item label="Incoming White Damage">
              x{chemical.whi_d}
            </LabeledList.Item>
          )}
          {chemical.bla_d !== 1 && (
            <LabeledList.Item label="Incoming Black Damage">
              x{chemical.bla_d}
            </LabeledList.Item>
          )}
          {chemical.pal_d !== 1 && (
            <LabeledList.Item label="Incoming Pale Damage">
              x{chemical.pal_d}
            </LabeledList.Item>
          )}
        </LabeledList>
      </Collapsible>
    </Table.Row>
  );
};

const ReactionTable = Table;

const ReactionRecipe = (props, context) => {
  const { reaction } = props;
  const requirements = reaction.requirements;
  const output = reaction.output;
  return (
    <Table.Row key={reaction.id}>
      <Collapsible
        title={reaction.title}
      >
        <Section title="Requirements">
          <LabeledList>
            {requirements.map(req => (
              <LabeledListItem key={req} label={req.name}>
                {req.amount}
              </LabeledListItem>
            ))}
          </LabeledList>
        </Section>
        <Section title="Output">
          <LabeledList>
            {output.map(out => (
              <LabeledListItem key={out} label={out.name}>
                {out.amount}
              </LabeledListItem>
            ))}
          </LabeledList>
        </Section>
      </Collapsible>
    </Table.Row>
  );
};
