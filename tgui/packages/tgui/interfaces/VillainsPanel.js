import { useBackend, useLocalState } from '../backend';
import { Button, Section, Box, Stack, ProgressBar, Collapsible, Input, Dropdown, NumberInput, Grid, Icon, Tooltip } from '../components';
import { Window } from '../layouts';

export const VillainsPanel = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    phase,
    signup_count,
    min_players,
    max_players,
    signed_up,
    character_selection_phase,
    available_characters,
    selected_character,
    time_remaining,
    is_admin,
    all_phases,
    // Evening phase data
    available_actions,
    inventory,
    living_players,
    is_villain,
    has_character,
    // Voting phase data
    voting_candidates,
    current_vote,
    // Investigation phase data
    evidence_list,
    // Alibi phase data
    current_speaker,
    alibi_queue,
    alibi_time_remaining,
    // Debug data
    debug_mode,
    debug_all_players,
    fake_player_count,
    // Victory points
    victory_points,
    results_players,
  } = data;

  return (
    <Window title="Villains of the Night" width={500} height={is_admin && debug_mode ? 800 : 600}>
      <Window.Content scrollable>
        <Stack vertical fill>
          <Stack.Item>
            <GameStatus
              phase={phase}
              signup_count={signup_count}
              min_players={min_players}
              max_players={max_players}
              time_remaining={time_remaining}
              victory_points={victory_points}
            />
          </Stack.Item>
          {phase === 'setup' && !character_selection_phase ? (
            <Stack.Item>
              <SignupSection
                signed_up={signed_up}
                signup_count={signup_count}
                max_players={max_players}
                act={act}
              />
            </Stack.Item>
          ) : phase === 'setup' && character_selection_phase ? (
            <Stack.Item grow>
              <CharacterSelection
                available_characters={available_characters}
                selected_character={selected_character}
                act={act}
              />
            </Stack.Item>
          ) : phase === 'evening' ? (
            has_character ? (
              <Stack.Item grow>
                <EveningActions
                  available_actions={available_actions}
                  inventory={inventory}
                  living_players={living_players}
                  is_villain={is_villain}
                  act={act}
                />
              </Stack.Item>
            ) : (
              <Stack.Item>
                <Section title="Evening Phase">
                  <Box color="gray">
                    You are spectating. Only players with characters can 
                    submit actions during the evening phase.
                  </Box>
                </Section>
              </Stack.Item>
            )
          ) : phase === 'investigation' || phase === 'alibi' ? (
            <Stack.Item grow>
              <InvestigationPhase
                evidence_list={evidence_list}
                phase={phase}
                current_speaker={current_speaker}
                alibi_queue={alibi_queue}
                alibi_time_remaining={alibi_time_remaining}
              />
            </Stack.Item>
          ) : phase === 'voting' ? (
            <Stack.Item grow>
              <VotingPhase
                voting_candidates={voting_candidates}
                current_vote={current_vote}
                act={act}
              />
            </Stack.Item>
          ) : phase === 'results' ? (
            <Stack.Item grow>
              <ResultsPhase results_players={results_players} />
            </Stack.Item>
          ) : null}
          {is_admin && Array.isArray(all_phases) && all_phases.length > 0 && (
            <>
              <Stack.Item>
                <AdminControls
                  phase={phase}
                  all_phases={all_phases}
                  act={act}
                />
              </Stack.Item>
              {debug_mode && (
                <Stack.Item>
                  <DebugControls
                    phase={phase}
                    all_players={debug_all_players}
                    fake_player_count={fake_player_count}
                    act={act}
                  />
                </Stack.Item>
              )}
            </>
          )}
        </Stack>
      </Window.Content>
    </Window>
  );
};

const GameStatus = props => {
  const { 
    phase, 
    signup_count, 
    min_players, 
    max_players, 
    time_remaining, 
    victory_points,
  } = props;

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
      <Stack vertical>
        <Stack.Item>
          <Box>
            <strong>Current Phase:</strong> {getPhaseText(phase)}
          </Box>
        </Stack.Item>
        <Stack.Item>
          <Box>
            <strong>Players Signed Up:</strong> {signup_count} / {max_players}
          </Box>
          <ProgressBar
            value={signup_count}
            minValue={0}
            maxValue={max_players}
            ranges={{
              good: [min_players, max_players],
              average: [Math.floor(min_players * 0.75), min_players],
              bad: [0, Math.floor(min_players * 0.75)],
            }}
          />
        </Stack.Item>
        {!!time_remaining && (
          <Stack.Item>
            <Box>
              <strong>Time Remaining:</strong> {
                Math.floor(time_remaining / 60)
              }:{String(time_remaining % 60).padStart(2, '0')}
            </Box>
          </Stack.Item>
        )}
        {victory_points !== undefined && phase !== 'setup' && (
          <Stack.Item>
            <Box>
              <strong>Your Victory Points:</strong>{' '}
              <span style={{ color: victory_points > 0 ? 'green' : victory_points < 0 ? 'red' : 'gray' }}>
                {victory_points}
              </span>
            </Box>
          </Stack.Item>
        )}
        <Stack.Item>
          <Box fontSize="0.9em" color="gray">
            Minimum players needed: {min_players}
          </Box>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const SignupSection = props => {
  const { signed_up, signup_count, max_players, act } = props;

  return (
    <Section title="Game Signup">
      <Stack vertical>
        <Stack.Item>
          <Box mb={2}>
            Sign up to play Villains of the Night, a social deduction game 
            where abnormalities must find the villain among them!
          </Box>
        </Stack.Item>
        <Stack.Item>
          {!signed_up ? (
            <Button
              content="Sign Up"
              icon="user-plus"
              color="good"
              disabled={signup_count >= max_players}
              onClick={() => act('signup')}
              fluid
            />
          ) : (
            <Stack vertical>
              <Stack.Item>
                <Box color="good" mb={1}>
                  You are signed up for the game!
                </Box>
              </Stack.Item>
              <Stack.Item>
                <Button
                  content="Leave Game"
                  icon="user-minus"
                  color="bad"
                  onClick={() => act('leave')}
                  fluid
                />
              </Stack.Item>
            </Stack>
          )}
        </Stack.Item>
      </Stack>
    </Section>
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

const CharacterSelection = props => {
  const { available_characters, selected_character, act } = props;

  if (!available_characters || available_characters.length === 0) {
    return (
      <Section title="Character Selection">
        <Box>No characters available.</Box>
      </Section>
    );
  }

  return (
    <Section title="Character Selection">
      <Box mb={2}>
        Select your character for this game. Each character has unique 
        abilities and traits.
      </Box>
      <Stack vertical>
        {available_characters.map(character => (
          <Stack.Item key={character.id}>
            <Collapsible
              title={
                <Stack>
                  <Stack.Item grow>
                    {character.name}
                  </Stack.Item>
                  {!!character.taken && (
                    <Stack.Item>
                      <Box color="red">
                        <Icon name="lock" /> Taken
                      </Box>
                    </Stack.Item>
                  )}
                  {!!(selected_character === character.id) && (
                    <Stack.Item>
                      <Box color="good">
                        <Icon name="check" /> Selected
                      </Box>
                    </Stack.Item>
                  )}
                </Stack>
              }
              open={selected_character === character.id}
              color={selected_character === character.id ? 'good' : character.taken ? 'bad' : 'default'}
            >
              <Box p={2}>
                <Stack vertical>
                  <Stack.Item>
                    <Box mb={2} fontSize="0.9em" italic>
                      {character.desc}
                    </Box>
                  </Stack.Item>
                  
                  {character.active_ability && (
                    <Stack.Item>
                      <Box mb={2} p={1} backgroundColor="rgba(255, 200, 0, 0.1)">
                        <Stack vertical>
                          <Stack.Item>
                            <Box bold color="yellow">
                              <Icon name="bolt" /> Active Ability: 
                              {character.active_ability.name}
                            </Box>
                          </Stack.Item>
                          <Stack.Item>
                            <Box 
                              fontSize="0.9em" 
                              italic 
                              color={getActionTypeColor(character.active_ability.type)}>
                              Type: {getActionTypeName(character.active_ability.type)} | 
                              Cost: {character.active_ability.cost}
                            </Box>
                          </Stack.Item>
                          <Stack.Item>
                            <Box fontSize="0.9em">
                              {character.active_ability.desc}
                            </Box>
                          </Stack.Item>
                        </Stack>
                      </Box>
                    </Stack.Item>
                  )}
                  
                  {character.passive_ability && (
                    <Stack.Item>
                      <Box mb={2} p={1} backgroundColor="rgba(0, 200, 255, 0.1)">
                        <Stack vertical>
                          <Stack.Item>
                            <Box bold color="cyan">
                              <Icon name="shield-alt" /> Passive Ability: {character.passive_ability.name}
                            </Box>
                          </Stack.Item>
                          <Stack.Item>
                            <Box fontSize="0.9em">
                              {character.passive_ability.desc}
                            </Box>
                          </Stack.Item>
                        </Stack>
                      </Box>
                    </Stack.Item>
                  )}
                  
                  <Stack.Item>
                    <Button
                      content={selected_character === character.id ? 'Selected' : 'Select Character'}
                      icon={selected_character === character.id ? 'check' : 'user'}
                      color={selected_character === character.id ? 'good' : 'default'}
                      disabled={character.taken || selected_character === character.id}
                      onClick={() => act('select_character', { character_id: character.id })}
                      fluid
                    />
                  </Stack.Item>
                </Stack>
              </Box>
            </Collapsible>
          </Stack.Item>
        ))}
      </Stack>
    </Section>
  );
};

const AdminControls = (props, context) => {
  const { phase, all_phases, act } = props;
  const [timerMinutes, setTimerMinutes] = useLocalState(context, 'timerMinutes', 1);
  const [ghostCkey, setGhostCkey] = useLocalState(context, 'ghostCkey', '');

  return (
    <Section title="Admin Controls" color="red">
      <Stack vertical>
        <Stack.Item>
          <Box color="yellow" mb={2}>
            <strong>Warning:</strong> Admin controls for testing and debugging
          </Box>
        </Stack.Item>
        
        <Stack.Item>
          <Box mb={1}>
            <strong>Game Control:</strong>
          </Box>
          <Stack>
            <Stack.Item grow>
              <Button
                content="Force Start Game"
                icon="play"
                color="orange"
                onClick={() => act('admin_force_start')}
                disabled={phase !== 'setup'}
              />
            </Stack.Item>
            <Stack.Item grow>
              <Button
                content="Force End Game"
                icon="stop"
                color="red"
                onClick={() => act('admin_force_end')}
              />
            </Stack.Item>
          </Stack>
        </Stack.Item>

        <Stack.Item>
          <Box mb={1}>
            <strong>Debug Mode:</strong>
          </Box>
          <Button
            content="Enable Debug Testing"
            icon="bug"
            color="purple"
            onClick={() => act('debug_create_fake_player')}
            tooltip="Activates debug mode with testing features"
            fluid
          />
        </Stack.Item>
        
        <Stack.Item>
          <Button
            content="Reveal Last Night's Actions"
            icon="eye"
            color="yellow"
            onClick={() => act('admin_reveal_actions')}
            tooltip="Shows all actions performed during the last nighttime phase"
            fluid
          />
        </Stack.Item>

        <Stack.Item>
          <Box mb={1}>
            <strong>Phase Control:</strong>
          </Box>
          <Button
            content="End Current Phase"
            icon="forward"
            color="orange"
            onClick={() => act('admin_end_phase')}
            tooltip="Immediately ends the current phase and progresses to the next"
            fluid
          />
        </Stack.Item>

        <Stack.Item>
          <Box mb={1}>
            <strong>Timer Control:</strong>
          </Box>
          <Stack>
            <Stack.Item grow>
              <NumberInput
                value={timerMinutes}
                minValue={0}
                maxValue={60}
                step={1}
                onChange={(e, value) => setTimerMinutes(value)}
                width="100%"
              />
            </Stack.Item>
            <Stack.Item>
              <Button
                content="Set Timer (min)"
                icon="clock"
                onClick={() => act('admin_set_timer', { minutes: timerMinutes })}
              />
            </Stack.Item>
          </Stack>
        </Stack.Item>

        <Stack.Item>
          <Box mb={1}>
            <strong>Player Management:</strong>
          </Box>
          <Stack>
            <Stack.Item grow>
              <Input
                value={ghostCkey}
                placeholder="Ghost ckey"
                onChange={(e, value) => setGhostCkey(value)}
                width="100%"
              />
            </Stack.Item>
            <Stack.Item>
              <Button
                content="Add Ghost"
                icon="user-plus"
                onClick={() => act('admin_add_ghost', { ckey: ghostCkey })}
                disabled={!ghostCkey}
              />
            </Stack.Item>
          </Stack>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const EveningActions = (props, context) => {
  const { 
    available_actions = {}, 
    inventory = [], 
    living_players = [], 
    is_villain = false, 
    act,
  } = props;
  const [mainAction, setMainAction] = useLocalState(context, 'mainAction', null);
  const [mainTarget, setMainTarget] = useLocalState(context, 'mainTarget', null);
  const [secondaryAction, setSecondaryAction] = useLocalState(context, 'secondaryAction', null);
  const [secondaryTarget, setSecondaryTarget] = useLocalState(context, 'secondaryTarget', null);

  // Build main action options
  const mainActionOptions = [
    { value: 'talk_trade', displayText: 'Talk/Trade' },
  ];

  if (available_actions?.active_ability) {
    mainActionOptions.push({
      value: 'ability',
      displayText: available_actions.active_ability.name,
    });
  }

  if (Array.isArray(inventory) && inventory.length > 0) {
    inventory.forEach(item => {
      if (item.cost === 'Main Action') {
        mainActionOptions.push({
          value: `item_${item.ref}`,
          displayText: `Use ${item.name}`,
        });
      }
    });
  }

  if (is_villain) {
    mainActionOptions.push({
      value: 'eliminate',
      displayText: 'Eliminate',
    });
  }

  // Build secondary action options
  const secondaryActionOptions = [];
  if (Array.isArray(inventory) && inventory.length > 0) {
    inventory.forEach(item => {
      if (item.cost === 'Secondary Action') {
        secondaryActionOptions.push({
          value: `item_${item.ref}`,
          displayText: `Use ${item.name}`,
        });
      }
    });
  }

  // Build target options
  const targetOptions = Array.isArray(living_players) ? living_players.map(player => ({
    value: player.ref,
    displayText: player.name,
  })) : [];

  const handleSubmit = () => {
    act('submit_evening_actions', {
      main_action: mainAction,
      main_target: mainTarget,
      secondary_action: secondaryAction,
      secondary_target: secondaryTarget,
    });
  };

  return (
    <Section title="Evening Actions">
      <Stack vertical>
        <Stack.Item>
          <Box mb={2}>
            Select your actions for tonight. All actions will be performed during the nighttime phase.
          </Box>
        </Stack.Item>

        <Stack.Item>
          <Box bold mb={1}>Main Action:</Box>
          <Stack>
            <Stack.Item grow>
              <Dropdown
                selected={mainAction}
                options={mainActionOptions || []}
                onSelected={(value) => setMainAction(value)}
                width="100%"
                placeholder="Select main action..."
                disabled={!mainActionOptions || mainActionOptions.length === 0}
              />
            </Stack.Item>
            {mainAction && (
              <Stack.Item grow>
                <Dropdown
                  selected={mainTarget}
                  options={targetOptions || []}
                  onSelected={(value) => setMainTarget(value)}
                  width="100%"
                  placeholder={
                    targetOptions && targetOptions.length > 0
                      ? "Select target..."
                      : "No targets available"
                  }
                  disabled={!targetOptions || targetOptions.length === 0}
                />
              </Stack.Item>
            )}
          </Stack>
        </Stack.Item>

        {secondaryActionOptions.length > 0 && (
          <Stack.Item>
            <Box bold mb={1}>Secondary Action (Optional):</Box>
            <Stack>
              <Stack.Item grow>
                <Dropdown
                  selected={secondaryAction}
                  options={secondaryActionOptions || []}
                  onSelected={(value) => setSecondaryAction(value)}
                  width="100%"
                  placeholder="Select secondary action..."
                  disabled={!secondaryActionOptions || secondaryActionOptions.length === 0}
                />
              </Stack.Item>
              {secondaryAction && (
                <Stack.Item grow>
                  <Dropdown
                    selected={secondaryTarget}
                    options={targetOptions || []}
                    onSelected={(value) => setSecondaryTarget(value)}
                    width="100%"
                    placeholder={
                    targetOptions && targetOptions.length > 0
                      ? "Select target..."
                      : "No targets available"
                  }
                    disabled={!targetOptions || targetOptions.length === 0}
                  />
                </Stack.Item>
              )}
            </Stack>
          </Stack.Item>
        )}

        <Stack.Item>
          <Button
            content="Submit Actions"
            icon="check"
            color="good"
            fluid
            disabled={!mainAction || !mainTarget}
            onClick={handleSubmit}
          />
        </Stack.Item>

        {mainAction && (
          <Stack.Item>
            <ActionDescription action={mainAction} actions={available_actions} inventory={inventory} />
          </Stack.Item>
        )}
      </Stack>
    </Section>
  );
};

const ActionDescription = props => {
  const { action, actions, inventory } = props;

  let description = '';
  let type = '';

  if (action === 'talk_trade') {
    description = 'Visit target player for 2 minutes to talk and trade items.';
    type = 'Typeless';
  } else if (action === 'ability' && actions?.active_ability) {
    description = actions.active_ability.description;
    type = actions.active_ability.type;
  } else if (action === 'eliminate') {
    description = 'Attempt to eliminate the target player.';
    type = 'Elimination';
  } else if (action.startsWith('item_') && inventory) {
    const itemRef = action.substring(5);
    const item = inventory.find(i => i.ref === itemRef);
    if (item) {
      description = item.description;
      type = item.type;
    }
  }

  return (
    <Box p={1} backgroundColor="#202020">
      <Box bold color={getActionTypeColor(type)}>
        Action Type: {getActionTypeName(type)}
      </Box>
      <Box mt={1} fontSize="0.9em">
        {description}
      </Box>
    </Box>
  );
};

const InvestigationPhase = props => {
  const { evidence_list, phase, current_speaker, alibi_queue, alibi_time_remaining } = props;

  if (phase === 'alibi') {
    return (
      <Section title="Alibi Phase">
        <Stack vertical>
          {current_speaker ? (
            <>
              <Stack.Item>
                <Box bold fontSize="1.2em" color="yellow">
                  Current Speaker: {current_speaker.name}
                </Box>
                {alibi_time_remaining && (
                  <Box>
                    Time Remaining: {alibi_time_remaining} seconds
                    {alibi_time_remaining <= 10 && (
                      <Box as="span" color="red"> (Hurry up!)</Box>
                    )}
                  </Box>
                )}
              </Stack.Item>
              
              <Stack.Item>
                <Box color="gray" italic>
                  Only {current_speaker.name} may speak normally. All others must whisper.
                </Box>
              </Stack.Item>
            </>
          ) : (
            <Stack.Item>
              <Box color="gray">Waiting for next speaker...</Box>
            </Stack.Item>
          )}
          
          {alibi_queue && alibi_queue.length > 0 && (
            <Stack.Item>
              <Box bold mt={2}>Speaking Queue:</Box>
              <Box backgroundColor="#1a1a1a" p={1}>
                {alibi_queue.map((player, index) => (
                  <Box key={index}>
                    {player.position}. {player.name}
                  </Box>
                ))}
              </Box>
            </Stack.Item>
          )}
          
          <Stack.Item>
            <Box fontSize="0.9em" color="cyan" mt={2}>
              <Icon name="info-circle" /> Each player has 30 seconds to present their alibi.
            </Box>
          </Stack.Item>
        </Stack>
      </Section>
    );
  }

  return (
    <Section title={phase === 'investigation' ? 'Investigation Phase' : 'Trial Briefing'}>
      <Stack vertical>
        <Stack.Item>
          <Box mb={2} color="yellow">
            {phase === 'investigation' 
              ? "Search the facility for evidence! Items and action residues have been scattered throughout."
              : "Review the evidence found during the investigation. You have 2 minutes to discuss before alibis begin."}
          </Box>
        </Stack.Item>
        
        {evidence_list && evidence_list.length > 0 ? (
          <Stack.Item>
            <Box bold mb={1}>Evidence Found:</Box>
            <Box 
              height="300px" 
              overflowY="scroll" 
              backgroundColor="#1a1a1a" 
              p={2}
              style={{ border: '1px solid #444' }}
            >
              {evidence_list.map((evidence, index) => {
                const isFound = evidence.includes('FOUND');
                const parts = evidence.split(' - ');
                return (
                  <Box key={index} mb={1}>
                    <Icon name="search" color="yellow" /> {parts[0]}
                    {parts[1] && (
                      <Box as="span" color="lime" ml={1}>
                        {' - ' + parts[1]}
                      </Box>
                    )}
                  </Box>
                );
              })}
            </Box>
          </Stack.Item>
        ) : (
          <Stack.Item>
            <Box color="gray" italic>
              No evidence has been found yet. Search the facility during the investigation phase!
            </Box>
          </Stack.Item>
        )}
        
        {phase === 'investigation' && (
          <Stack.Item>
            <Box fontSize="0.9em" color="cyan">
              <Icon name="info-circle" /> Tips:
              <br />• Look for items with yellow outlines - these were used during the night
              <br />• Used items are scattered as evidence throughout the facility
              <br />• Check what items were found to piece together what happened
            </Box>
          </Stack.Item>
        )}
      </Stack>
    </Section>
  );
};

const VotingPhase = props => {
  const { voting_candidates, current_vote, act } = props;

  if (!voting_candidates || voting_candidates.length === 0) {
    return (
      <Section title="Voting Phase">
        <Box>No candidates available for voting.</Box>
      </Section>
    );
  }

  return (
    <Section title="Voting Phase">
      <Stack vertical>
        <Stack.Item>
          <Box mb={2}>
            Select the player you believe to be the villain. Click on their portrait to cast your vote.
          </Box>
        </Stack.Item>
        <Stack.Item>
          <Grid width="100%">
            {voting_candidates.map(candidate => (
              <Grid.Column key={candidate.ref} size={4}>
                <VoteCard
                  candidate={candidate}
                  isSelected={current_vote === candidate.ref}
                  act={act}
                />
              </Grid.Column>
            ))}
          </Grid>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const VoteCard = props => {
  const { candidate, isSelected, act } = props;

  return (
    <Box
      p={1}
      m={0.5}
      textAlign="center"
      backgroundColor={isSelected ? '#441111' : '#1a1a1a'}
      style={{
        border: isSelected ? '3px solid #ff0000' : '1px solid #444',
        cursor: 'pointer',
        transition: 'all 0.2s',
      }}
      onClick={() => act('vote_player', { player_ref: candidate.ref })}
    >
      <Box fontSize="1.2em" bold mb={1}>
        {candidate.name}
      </Box>
      <Box fontSize="0.9em" color="gray">
        {candidate.character}
      </Box>
      {candidate.vote_count > 0 && (
        <Box mt={1} color="yellow">
          Votes: {candidate.vote_count}
        </Box>
      )}
      {isSelected && (
        <Box mt={1} color="red">
          <Icon name="check-circle" /> Your Vote
        </Box>
      )}
    </Box>
  );
};

const DebugControls = (props, context) => {
  const { phase, all_players, fake_player_count, act } = props;
  const [fakePlayerCount, setFakePlayerCount] = useLocalState(context, 'fakePlayerCount', 5);
  const [selectedPlayer, setSelectedPlayer] = useLocalState(context, 'selectedPlayer', null);

  return (
    <Section title="Debug Controls" color="purple">
      <Stack vertical>
        <Stack.Item>
          <Box color="yellow" mb={2}>
            <Icon name="bug" /> Debug Mode Active - {fake_player_count} fake players created
          </Box>
        </Stack.Item>

        <Stack.Item>
          <Collapsible title="Player Management" open>
            <Stack vertical>
              <Stack.Item>
                <Stack>
                  <Stack.Item grow>
                    <Button
                      content="Create Fake Player"
                      icon="user-plus"
                      onClick={() => act('debug_create_fake_player')}
                      fluid
                    />
                  </Stack.Item>
                  <Stack.Item>
                    <NumberInput
                      value={fakePlayerCount}
                      minValue={1}
                      maxValue={11}
                      onChange={(e, value) => setFakePlayerCount(value)}
                      width="60px"
                    />
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      content={`Create ${fakePlayerCount} Fake Players`}
                      icon="users"
                      onClick={() => act('debug_create_multiple_fake', { count: fakePlayerCount })}
                    />
                  </Stack.Item>
                </Stack>
              </Stack.Item>

              {all_players && all_players.length > 0 && (
                <Stack.Item>
                  <Box mb={1} bold>All Players:</Box>
                  <Box height="200px" overflowY="scroll" backgroundColor="#1a1a1a" p={1}>
                    {all_players.map(player => (
                      <Box
                        key={player.ref}
                        p={0.5}
                        mb={0.5}
                        backgroundColor={selectedPlayer === player.ref ? '#333' : 'transparent'}
                        onClick={() => setSelectedPlayer(player.ref)}
                        style={{ cursor: 'pointer' }}
                      >
                        <Stack>
                          <Stack.Item grow>
                            <Box>
                              {player.name} ({player.character})
                              {!!player.is_fake && <Box as="span" color="cyan"> [AI]</Box>}
                              {!!player.is_villain && <Box as="span" color="red"> [VILLAIN]</Box>}
                              {!player.alive && <Box as="span" color="gray"> [DEAD]</Box>}
                            </Box>
                          </Stack.Item>
                          <Stack.Item>
                            Room: {player.room}
                          </Stack.Item>
                        </Stack>
                      </Box>
                    ))}
                  </Box>
                </Stack.Item>
              )}

              {selectedPlayer && (
                <Stack.Item>
                  <Box mb={1}>Selected Player Actions:</Box>
                  <Stack>
                    <Stack.Item grow>
                      <Button
                        content="Kill"
                        icon="skull"
                        color="red"
                        onClick={() => act('debug_kill_player', { player_ref: selectedPlayer })}
                      />
                    </Stack.Item>
                    <Stack.Item grow>
                      <Button
                        content="Set as Villain"
                        icon="mask"
                        color="orange"
                        onClick={() => act('debug_set_villain', { player_ref: selectedPlayer })}
                      />
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
              )}
            </Stack>
          </Collapsible>
        </Stack.Item>

        <Stack.Item>
          <Collapsible title="Game Actions">
            <Stack vertical>
              <Stack.Item>
                <Button
                  content="Spawn All Items"
                  icon="box-open"
                  color="blue"
                  onClick={() => act('debug_spawn_items')}
                  fluid
                />
              </Stack.Item>
              <Stack.Item>
                <Button
                  content="Give Items to All Fake Players"
                  icon="gift"
                  color="purple"
                  onClick={() => act('debug_give_items_to_fakes')}
                  fluid
                />
              </Stack.Item>
              <Stack.Item>
                <Button
                  content="Control Fake Player Action"
                  icon="gamepad"
                  color="cyan"
                  onClick={() => act('debug_control_fake_action')}
                  disabled={phase !== 'evening'}
                  fluid
                />
              </Stack.Item>
              <Stack.Item>
                <Button
                  content="Simulate Fake Player Actions"
                  icon="robot"
                  color="green"
                  onClick={() => act('debug_simulate_actions')}
                  disabled={phase !== 'evening'}
                  fluid
                />
              </Stack.Item>
              <Stack.Item>
                <Button
                  content="Instant Process Actions"
                  icon="fast-forward"
                  color="orange"
                  onClick={() => act('debug_instant_process')}
                  disabled={phase !== 'nighttime'}
                  fluid
                />
              </Stack.Item>
              <Stack.Item>
                <Button
                  content="Show Game State"
                  icon="info-circle"
                  color="teal"
                  onClick={() => act('debug_show_state')}
                  fluid
                />
              </Stack.Item>
            </Stack>
          </Collapsible>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const ResultsPhase = props => {
  const { results_players } = props;

  return (
    <Section title="Results - Victory Points">
      <Stack vertical>
        <Stack.Item>
          <Box bold fontSize="1.2em">
            Current Standings:
          </Box>
        </Stack.Item>
        {results_players && results_players.length > 0 ? (
          results_players
            .sort((a, b) => b.victory_points - a.victory_points)
            .map(player => (
              <Stack.Item key={player.name}>
                <Box>
                  <Stack>
                    <Stack.Item grow>
                      <span>
                        {player.name} ({player.character})
                        {player.is_spectator && <span color="gray"> [OUT]</span>}
                      </span>
                    </Stack.Item>
                    <Stack.Item>
                      <Box
                        bold
                        color={
                          player.victory_points > 0
                            ? 'green'
                            : player.victory_points < 0
                              ? 'red'
                              : 'gray'
                        }>
                        {player.victory_points} point{
                          player.victory_points !== 1 && 's'
                        }
                      </Box>
                    </Stack.Item>
                  </Stack>
                </Box>
              </Stack.Item>
            ))
        ) : (
          <Stack.Item>
            <Box color="gray">Waiting for results...</Box>
          </Stack.Item>
        )}
      </Stack>
    </Section>
  );
};