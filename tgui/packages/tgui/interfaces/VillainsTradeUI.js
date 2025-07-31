import { useBackend } from '../backend';
import { Button, Section, Box, Stack, Grid, ProgressBar, LabeledList, Divider } from '../components';
import { Window } from '../layouts';

export const VillainsTradeUI = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    my_name,
    partner_name,
    my_inventory,
    partner_inventory,
    my_offer,
    partner_offer,
    my_ready,
    partner_ready,
    trade_complete,
    time_remaining,
  } = data;

  return (
    <Window title="Trade Session" width={700} height={500}>
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <Section title="Trade Information">
              <LabeledList>
                <LabeledList.Item label="Trading With">
                  {partner_name}
                </LabeledList.Item>
                <LabeledList.Item label="Time Remaining">
                  <ProgressBar
                    value={time_remaining}
                    maxValue={120}
                    color={time_remaining < 30 ? 'bad' : 'good'}>
                    {time_remaining} seconds
                  </ProgressBar>
                </LabeledList.Item>
              </LabeledList>
            </Section>
          </Stack.Item>

          <Stack.Item grow>
            <Grid>
              <Grid.Column>
                <PlayerInventory
                  title={my_name + "'s Inventory"}
                  inventory={my_inventory}
                  offer={my_offer}
                  ready={my_ready}
                  isOwner
                  act={act}
                />
              </Grid.Column>

              <Grid.Column>
                <PlayerInventory
                  title={partner_name + "'s Inventory"}
                  inventory={partner_inventory}
                  offer={partner_offer}
                  ready={partner_ready}
                  isOwner={false}
                  act={act}
                />
              </Grid.Column>
            </Grid>
          </Stack.Item>

          <Stack.Item>
            <TradeControls
              my_ready={my_ready}
              partner_ready={partner_ready}
              trade_complete={trade_complete}
              act={act}
            />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const PlayerInventory = (props, context) => {
  const { title, inventory, offer, ready, isOwner, act } = props;

  return (
    <Section
      title={title}
      fill
      buttons={
        ready && (
          <Box color="good">
            Ready!
          </Box>
        )
      }>
      <Stack vertical fill>
        <Stack.Item grow>
          <Section title="Inventory" scrollable fill>
            {inventory.length > 0 ? (
              inventory.map(item => (
                <Box
                  key={item.ref}
                  p={1}
                  className={offer.includes(item.ref) ? 'dimmed' : ''}>
                  <Stack>
                    <Stack.Item grow>
                      <Box color={item.rarity_color || 'white'}>
                        {item.name}
                      </Box>
                      <Box fontSize="0.9em" color="gray">
                        {item.desc}
                      </Box>
                    </Stack.Item>
                    {isOwner && !offer.includes(item.ref) && (
                      <Stack.Item>
                        <Button
                          content="Offer"
                          onClick={() => act('offer_item', { item_ref: item.ref })}
                          disabled={ready}
                        />
                      </Stack.Item>
                    )}
                  </Stack>
                </Box>
              ))
            ) : (
              <Box color="gray">No items</Box>
            )}
          </Section>
        </Stack.Item>

        <Stack.Item>
          <Divider />
        </Stack.Item>

        <Stack.Item>
          <Section title="Offered Items">
            {offer.length > 0 ? (
              offer.map(itemRef => {
                const item = inventory.find(i => i.ref === itemRef);
                if (!item) return null;
                return (
                  <Box key={item.ref} p={1}>
                    <Stack>
                      <Stack.Item grow>
                        <Box color={item.rarity_color || 'white'}>
                          {item.name}
                        </Box>
                      </Stack.Item>
                      {isOwner && (
                        <Stack.Item>
                          <Button
                            content="Remove"
                            color="bad"
                            onClick={() => act('remove_offer', { item_ref: item.ref })}
                            disabled={ready}
                          />
                        </Stack.Item>
                      )}
                    </Stack>
                  </Box>
                );
              })
            ) : (
              <Box color="gray">No items offered</Box>
            )}
          </Section>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const TradeControls = (props, context) => {
  const { my_ready, partner_ready, trade_complete, act } = props;

  if (trade_complete) {
    return (
      <Section>
        <Box textAlign="center" fontSize="1.2em" color="good">
          Trade Complete!
        </Box>
      </Section>
    );
  }

  return (
    <Section>
      <Stack>
        <Stack.Item grow>
          <Button
            fluid
            content={my_ready ? "Cancel Ready" : "Ready to Trade"}
            color={my_ready ? "bad" : "good"}
            onClick={() => act('toggle_ready')}
          />
        </Stack.Item>
        {my_ready && partner_ready && (
          <Stack.Item>
            <Button
              content="Confirm Trade"
              color="good"
              icon="handshake"
              onClick={() => act('confirm_trade')}
            />
          </Stack.Item>
        )}
        <Stack.Item>
          <Button
            content="Cancel Trade"
            color="bad"
            onClick={() => act('cancel_trade')}
          />
        </Stack.Item>
      </Stack>
    </Section>
  );
};
