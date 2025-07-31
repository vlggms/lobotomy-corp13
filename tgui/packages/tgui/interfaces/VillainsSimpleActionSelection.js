import { useBackend } from '../backend';
import { Button, Section, Box, Stack, Flex } from '../components';
import { Window } from '../layouts';

export const VillainsSimpleActionSelection = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    character_name,
    is_villain,
    available_actions = [],
    secondary_actions = [],
    available_targets = [],
    selected_action,
    selected_target,
    selected_secondary_action,
    selected_secondary_target,
    can_submit,
    phase_timer,
  } = data;

  return (
    <Window title="Select Night Actions" width={600} height={700}>
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <Section title="Evening Phase">
              <Box color="gray" mb={1}>
                {character_name} - Select your action for tonight
              </Box>
              {!!phase_timer && (
                <Box color="yellow">
                  Time remaining: {phase_timer} seconds
                </Box>
              )}
              {!!is_villain && (
                <Box color="red" bold mt={1}>
                  You are the villain! You have access to the Eliminate action.
                </Box>
              )}
            </Section>
          </Stack.Item>

          <Stack.Item grow>
            <Stack vertical fill>
              {/* Main Action Section */}
              <Stack.Item grow>
                <Stack fill>
                  <Stack.Item grow basis={0}>
                    <Section title="1. Choose Main Action" fill scrollable>
                      <Stack vertical>
                        {available_actions.map(action => (
                          <Stack.Item key={action.id}>
                            <Button
                              fluid
                              selected={selected_action === action.id}
                              onClick={() => act('select_action', { action_id: action.id })}
                              tooltip={action.desc}
                              color={action.type === 'elimination' ? 'red' : 'transparent'}>
                              <Stack>
                                <Stack.Item grow>
                                  <Box bold>{action.name}</Box>
                                  <Box fontSize="0.9em" opacity={0.6}>
                                    {action.type} - {action.cost}
                                  </Box>
                                </Stack.Item>
                              </Stack>
                            </Button>
                          </Stack.Item>
                        ))}
                      </Stack>
                    </Section>
                  </Stack.Item>

                  {!!selected_action && (
                    <Stack.Item grow basis={0}>
                      <Section title="2. Choose Target" fill scrollable>
                        <Stack vertical>
                          {available_targets.map(target => (
                            <Stack.Item key={target.ref}>
                              <Button
                                fluid
                                selected={selected_target === target.ref}
                                disabled={!target.can_target}
                                onClick={() => act(
                                  'select_target',
                                  { target_ref: target.ref }
                                )}
                                tooltip={target.can_target ? null : target.reason}>
                                <Box>
                                  {target.name}
                                  {!!target.is_self && " (You)"}
                                </Box>
                              </Button>
                            </Stack.Item>
                          ))}
                        </Stack>
                      </Section>
                    </Stack.Item>
                  )}
                </Stack>
              </Stack.Item>

              {/* Secondary Action Section */}
              {secondary_actions.length > 0 && (
                <Stack.Item grow>
                  <Stack fill>
                    <Stack.Item grow basis={0}>
                      <Section title="3. Choose Secondary Action (Optional)" fill scrollable>
                        <Stack vertical>
                          {secondary_actions.map(action => (
                            <Stack.Item key={action.id}>
                              <Button
                                fluid
                                selected={
                                  selected_secondary_action
                                    === action.id
                                }
                                onClick={() => act(
                                  'select_secondary_action',
                                  { action_id: action.id }
                                )}
                                tooltip={action.desc}
                                color="transparent">
                                <Stack>
                                  <Stack.Item grow>
                                    <Box bold>{action.name}</Box>
                                    <Box fontSize="0.9em" opacity={0.6}>
                                      {action.type} - {action.cost}
                                    </Box>
                                  </Stack.Item>
                                </Stack>
                              </Button>
                            </Stack.Item>
                          ))}
                        </Stack>
                      </Section>
                    </Stack.Item>

                    {!!selected_secondary_action && (
                      <Stack.Item grow basis={0}>
                        <Section title="4. Choose Secondary Target" fill scrollable>
                          <Stack vertical>
                            {available_targets.map(target => (
                              <Stack.Item key={target.ref}>
                                <Button
                                  fluid
                                  selected={
                                    selected_secondary_target
                                      === target.ref
                                  }
                                  disabled={!target.can_target}
                                  onClick={() => act(
                                    'select_secondary_target',
                                    { target_ref: target.ref }
                                  )}
                                  tooltip={target.can_target ? null : target.reason}>
                                  <Box>
                                    {target.name}
                                    {!!target.is_self && " (You)"}
                                  </Box>
                                </Button>
                              </Stack.Item>
                            ))}
                          </Stack>
                        </Section>
                      </Stack.Item>
                    )}
                  </Stack>
                </Stack.Item>
              )}
            </Stack>
          </Stack.Item>

          <Stack.Item>
            <Section>
              <Flex>
                <Flex.Item grow>
                  <Button
                    fluid
                    icon="check"
                    content="Submit Action"
                    color="good"
                    disabled={!can_submit}
                    onClick={() => act('submit')}
                  />
                </Flex.Item>
                <Flex.Item ml={1}>
                  <Button
                    icon="undo"
                    content="Clear"
                    color="bad"
                    onClick={() => act('clear')}
                  />
                </Flex.Item>
              </Flex>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};