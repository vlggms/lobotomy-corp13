import { useBackend } from '../backend';
import { Button, Section, Box, Stack, Dropdown, Divider, Icon } from '../components';
import { Window } from '../layouts';

const getActionTypeColor = type => {
  const colors = {
    'Investigative': 'blue',
    'Protective': 'green',
    'Suppressive': 'orange',
    'Elimination': 'red',
    'Typeless': 'gray',
  };
  return colors[type] || 'white';
};

const getActionTypeIcon = type => {
  const icons = {
    'Investigative': 'search',
    'Protective': 'shield-alt',
    'Suppressive': 'ban',
    'Elimination': 'skull',
    'Typeless': 'circle',
  };
  return icons[type] || 'question';
};

export const VillainsActionSelection = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    character_name,
    is_villain,
    main_actions = [],
    secondary_actions = [],
    available_targets = [],
    secondary_targets = [],
    selected_main_action,
    selected_main_target,
    selected_secondary_action,
    selected_secondary_target,
    main_self_target_only,
    main_no_self_target,
  } = data;

  // Build dropdown options
  const mainActionOptions = main_actions.map(action => ({
    value: action.id,
    displayText: action.name,
  }));

  const secondaryActionOptions = secondary_actions.map(action => ({
    value: action.id,
    displayText: action.name,
  }));

  // Filter targets based on restrictions
  const mainTargetOptions = available_targets
    .filter(target => target.can_target)
    .map(target => ({
      value: target.ref,
      displayText: target.name,
    }));

  const secondaryTargetOptions = (secondary_targets || available_targets)
    .filter(target => target.can_target)
    .map(target => ({
      value: target.ref,
      displayText: target.name,
    }));

  // Find selected action details
  const selectedMainActionDetails = main_actions.find(
    a => a.id === selected_main_action
  );
  const selectedSecondaryActionDetails = secondary_actions.find(
    a => a.id === selected_secondary_action
  );

  const canSubmit = selected_main_action && selected_main_target;

  return (
    <Window title="Select Night Actions" width={500} height={600}>
      <Window.Content scrollable>
        <Stack vertical fill>
          <Stack.Item>
            <Section title={`${character_name}'s Actions`}>
              <Box color="gray" mb={2}>
                Select your actions for tonight. All actions will be 
                performed during the nighttime phase in order of priority.
              </Box>
              {is_villain && (
                <Box color="red" mb={2}>
                  <Icon name="skull" /> You are the villain! You can use the Eliminate action.
                </Box>
              )}
            </Section>
          </Stack.Item>

          <Stack.Item>
            <Section title="Main Action" color="yellow">
              <Stack vertical>
                <Stack.Item>
                  <Box mb={1}>
                    <strong>Select Action:</strong>
                  </Box>
                  <Dropdown
                    selected={selected_main_action}
                    options={mainActionOptions}
                    onSelected={value => act('select_main_action', { action_id: value })}
                    width="100%"
                    placeholder="Choose your main action..."
                  />
                </Stack.Item>

                {selectedMainActionDetails && (
                  <>
                    <Stack.Item>
                      <Box mt={2} p={1} backgroundColor="rgba(255, 255, 255, 0.1)">
                        <Stack vertical>
                          <Stack.Item>
                            <Box
                              color={getActionTypeColor(
                                selectedMainActionDetails.type
                              )}>
                              <Icon
                                name={getActionTypeIcon(
                                  selectedMainActionDetails.type
                                )}
                              />
                              {' Type: '}{selectedMainActionDetails.type}
                            </Box>
                          </Stack.Item>
                          <Stack.Item>
                            <Box fontSize="0.9em" italic>
                              {selectedMainActionDetails.desc}
                            </Box>
                          </Stack.Item>
                        </Stack>
                      </Box>
                    </Stack.Item>

                    <Stack.Item>
                      <Box mt={2} mb={1}>
                        <strong>Select Target:</strong>
                        {main_self_target_only && (
                          <Box color="yellow" fontSize="0.9em">
                            (This action can only target yourself)
                          </Box>
                        )}
                        {main_no_self_target && (
                          <Box color="yellow" fontSize="0.9em">
                            (You cannot target yourself with this action)
                          </Box>
                        )}
                      </Box>
                      <Dropdown
                        selected={selected_main_target}
                        options={mainTargetOptions}
                        onSelected={value => act('select_main_target', { target_ref: value })}
                        width="100%"
                        placeholder="Choose your target..."
                        disabled={mainTargetOptions.length === 0}
                      />
                    </Stack.Item>
                  </>
                )}
              </Stack>
            </Section>
          </Stack.Item>

          {secondary_actions.length > 0 && (
            <Stack.Item>
              <Section title="Secondary Action (Optional)" color="cyan">
                <Stack vertical>
                  <Stack.Item>
                    <Box mb={1}>
                      <strong>Select Action:</strong>
                    </Box>
                    <Dropdown
                      selected={selected_secondary_action}
                      options={[{ value: null, displayText: 'None' }, ...secondaryActionOptions]}
                      onSelected={value => act('select_secondary_action', { action_id: value })}
                      width="100%"
                      placeholder="Choose your secondary action..."
                    />
                  </Stack.Item>

                  {selectedSecondaryActionDetails && (
                    <>
                      <Stack.Item>
                        <Box 
                          mt={2} 
                          p={1} 
                          backgroundColor="rgba(255, 255, 255, 0.1)">
                          <Stack vertical>
                            <Stack.Item>
                              <Box
                                color={getActionTypeColor(
                                  selectedSecondaryActionDetails.type
                                )}>
                                <Icon
                                  name={getActionTypeIcon(
                                    selectedSecondaryActionDetails.type
                                  )}
                                />
                                {' Type: '}{selectedSecondaryActionDetails.type}
                              </Box>
                            </Stack.Item>
                            <Stack.Item>
                              <Box fontSize="0.9em" italic>
                                {selectedSecondaryActionDetails.desc}
                              </Box>
                            </Stack.Item>
                          </Stack>
                        </Box>
                      </Stack.Item>

                      <Stack.Item>
                        <Box mt={2} mb={1}>
                          <strong>Select Target:</strong>
                        </Box>
                        <Dropdown
                          selected={selected_secondary_target}
                          options={secondaryTargetOptions}
                          onSelected={value => act(
                            'select_secondary_target',
                            { target_ref: value }
                          )}
                          width="100%"
                          placeholder="Choose your target..."
                        />
                      </Stack.Item>
                    </>
                  )}
                </Stack>
              </Section>
            </Stack.Item>
          )}

          <Stack.Item>
            <Section>
              <Stack>
                <Stack.Item grow>
                  <Button
                    content="Submit Actions"
                    icon="check"
                    color="good"
                    disabled={!canSubmit}
                    onClick={() => act('submit_actions')}
                    fluid
                  />
                </Stack.Item>
                <Stack.Item grow>
                  <Button
                    content="Clear All"
                    icon="undo"
                    color="bad"
                    onClick={() => act('clear_actions')}
                    fluid
                  />
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>

          <Stack.Item>
            <Section title="Action Priority Order">
              <Box fontSize="0.9em">
                <Stack vertical>
                  <Stack.Item>
                    <Box color="orange">1. Suppressive</Box>
                  </Stack.Item>
                  <Stack.Item>
                    <Box color="green">2. Protective</Box>
                  </Stack.Item>
                  <Stack.Item>
                    <Box color="blue">3. Investigative</Box>
                  </Stack.Item>
                  <Stack.Item>
                    <Box color="gray">4. Typeless</Box>
                  </Stack.Item>
                  <Stack.Item>
                    <Box color="red">5. Elimination</Box>
                  </Stack.Item>
                </Stack>
              </Box>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
