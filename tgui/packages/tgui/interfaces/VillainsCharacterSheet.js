import { useBackend } from '../backend';
import { Button, Section, Box, Stack, Icon, Tooltip, ProgressBar } from '../components';
import { Window } from '../layouts';

export const VillainsCharacterSheet = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    character_name,
    character_icon,
    character_portrait,
    portrait_base64,
    active_ability,
    passive_ability,
    inventory,
    max_items,
    is_villain,
    current_phase,
    time_remaining,
    victory_points,
    voting_candidates,
    current_vote,
  } = data;

  return (
    <Window title="Character Sheet" width={450} height={600}>
      <Window.Content scrollable>
        <Stack vertical fill>
          {!!current_phase && (
            <Stack.Item>
              <GamePhaseStatus
                phase={current_phase}
                time_remaining={time_remaining}
              />
            </Stack.Item>
          )}
          <Stack.Item>
            <CharacterInfo
              name={character_name}
              icon={character_icon}
              portrait={character_portrait}
              portrait_base64={portrait_base64}
              is_villain={is_villain}
              victory_points={victory_points}
            />
          </Stack.Item>
          <Stack.Item>
            <AbilitiesSection
              active={active_ability}
              passive={passive_ability}
            />
          </Stack.Item>
          {current_phase === 'voting' && voting_candidates && (
            <Stack.Item>
              <VotingSection
                candidates={voting_candidates}
                current_vote={current_vote}
                act={act}
              />
            </Stack.Item>
          )}
          <Stack.Item grow>
            <InventorySection
              inventory={inventory}
              max_items={max_items}
              act={act}
            />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const GamePhaseStatus = props => {
  const { phase, time_remaining } = props;

  const getPhaseText = phase => {
    const phases = {
      setup: 'Game Setup',
      morning: 'Morning Phase',
      evening: 'Evening Phase',
      nighttime: 'Nighttime Phase',
      investigation: 'Investigation Phase',
      alibi: 'Alibi Phase',
      discussion: 'Discussion Phase',
      voting: 'Voting Phase',
      results: 'Results Phase',
    };
    return phases[phase] || 'Unknown Phase';
  };

  return (
    <Section title="Game Status">
      <Stack>
        <Stack.Item grow>
          <Box>
            <strong>Current Phase:</strong> {getPhaseText(phase)}
          </Box>
        </Stack.Item>
        {!!time_remaining && (
          <Stack.Item>
            <Box>
              <strong>Time:</strong> {Math.floor(time_remaining / 60)}:{String(time_remaining % 60).padStart(2, '0')}
            </Box>
          </Stack.Item>
        )}
      </Stack>
    </Section>
  );
};

const CharacterInfo = props => {
  const { 
    name, 
    icon, 
    portrait, 
    portrait_base64, 
    is_villain, 
    victory_points 
  } = props;

  return (
    <Section title="Character Information">
      <Stack>
        <Stack.Item>
          <Box
            width="128px"
            height="128px"
            position="relative"
            mr={2}
          >
            {!!portrait_base64 && (
              <Box
                as="img"
                src={`data:image/png;base64,${portrait_base64}`}
                width="100%"
                height="100%"
                style={{
                  'object-fit': 'contain',
                  '-ms-interpolation-mode': 'nearest-neighbor',
                  'image-rendering': 'pixelated',
                }}
              />
            )}
          </Box>
        </Stack.Item>
        <Stack.Item grow>
          <Box fontSize="1.5em" bold>
            {name}
          </Box>
          {!!is_villain && (
            <Box color="red" mt={1}>
              <Icon name="skull" /> You are the Villain!
            </Box>
          )}
          {victory_points !== undefined && (
            <Box mt={1}>
              <Icon name="trophy" color="gold" /> Victory Points: {victory_points}
            </Box>
          )}
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const AbilitiesSection = props => {
  const { active, passive } = props;

  return (
    <Section title="Abilities">
      <Stack vertical>
        {!!active && (
          <Stack.Item>
            <Box mb={2}>
              <Box bold color="yellow">
                <Icon name="bolt" /> Active Ability: {active.name}
              </Box>
              <Box italic fontSize="0.9em" color={getActionTypeColor(active.type)}>
                Type: {getActionTypeName(active.type)} | Cost: {active.cost}
              </Box>
              <Box mt={1}>
                {active.description}
              </Box>
            </Box>
          </Stack.Item>
        )}
        {!!passive && (
          <Stack.Item>
            <Box>
              <Box bold color="cyan">
                <Icon name="shield-alt" /> Passive Ability: {passive.name}
              </Box>
              <Box mt={1}>
                {passive.description}
              </Box>
            </Box>
          </Stack.Item>
        )}
      </Stack>
    </Section>
  );
};

const InventorySection = props => {
  const { inventory, max_items, act } = props;

  return (
    <Section 
      title={`Inventory (${inventory ? inventory.length : 0}/${max_items})`}>
      {inventory && inventory.length > 0 ? (
        <Stack vertical>
          {inventory.map((item, index) => (
            <Stack.Item key={index}>
              <ItemCard item={item} act={act} />
            </Stack.Item>
          ))}
        </Stack>
      ) : (
        <Box color="gray" italic>
          No items in inventory
        </Box>
      )}
      <Box mt={2} fontSize="0.9em" color="gray">
        <Icon name="info-circle" /> Click on an item to drop it
      </Box>
    </Section>
  );
};

const ItemCard = props => {
  const { item, act } = props;

  return (
    <Box
      className="candystripe"
      p={1}
      style={{
        border: '2px solid',
        borderColor: item.fresh ? '#4f7942' : '#888',
        cursor: 'pointer',
      }}
      onClick={() => act('drop_item', { item_ref: item.ref })}
    >
      <Stack justify="space-between">
        <Stack.Item grow>
          <Box bold>
            {item.name}
            {!!item.fresh && (
              <Tooltip content="Fresh item - can be picked up">
                <Icon name="leaf" color="green" ml={1} />
              </Tooltip>
            )}
          </Box>
          <Box fontSize="0.9em" italic color={getActionTypeColor(item.type)}>
            Type: {getActionTypeName(item.type)} | Cost: {item.cost}
          </Box>
          <Box fontSize="0.9em" mt={1}>
            {item.description}
          </Box>
        </Stack.Item>
        <Stack.Item>
          <Icon name="trash" size={1.5} color="gray" />
        </Stack.Item>
      </Stack>
    </Box>
  );
};

const getActionTypeName = type => {
  const typeNames = {
    1: 'Suppressive',
    2: 'Protective',
    3: 'Investigative',
    4: 'Typeless',
    5: 'Elimination',
  };
  return typeNames[type] || type;
};

const getActionTypeColor = type => {
  // Convert numeric type to name if needed
  const typeName = typeof type === 'number' ? getActionTypeName(type) : type;
  
  const colors = {
    'Investigative': 'blue',
    'Protective': 'green',
    'Suppressive': 'orange',
    'Elimination': 'red',
    'Typeless': 'gray',
  };
  return colors[typeName] || 'white';
};

const VotingSection = props => {
  const { candidates, current_vote, act } = props;

  return (
    <Section title="Voting Phase">
      <Box mb={2} color="yellow">
        <Icon name="exclamation-triangle" /> Vote for who you think is the villain!
      </Box>
      {current_vote && (
        <Box mb={2} color="lime">
          <Icon name="check" /> You voted for: {current_vote}
        </Box>
      )}
      <Stack vertical>
        {candidates.map(candidate => (
          <Stack.Item key={candidate.ref}>
            <Button
              fluid
              content={candidate.name}
              selected={current_vote === candidate.name}
              onClick={() => act('vote_player', { player_ref: candidate.ref })}
              icon={current_vote === candidate.name ? "check" : "vote-yea"}
            />
          </Stack.Item>
        ))}
      </Stack>
    </Section>
  );
};
