// THIS IS A LOBOTOMYCORPORATION UI FILE

import { useBackend, useLocalState } from '../backend';
import { Box, Button, LabeledList, NoticeBox, Section, Tabs } from '../components';
import { Window } from '../layouts';

export const AuxiliaryManagerConsole = (props, context) => {
  const [tab, setTab] = useLocalState(context, 'tab', 1);

  return (
    <Window title="Auxiliary Managerial Console" width="650" height="600">
      <Window.Content>
        <Tabs>
          <Tabs.Tab
            icon="list"
            lineHeight="23px"
            selected={tab === 1}
            onClick={() => setTab(1)}>
            Facility Upgrade system
          </Tabs.Tab>
          <Tabs.Tab
            icon="list"
            lineHeight="23px"
            selected={tab === 2}
            onClick={() => setTab(2)}>
            Core Suppression system
          </Tabs.Tab>
        </Tabs>
        {tab === 1 && <FacilityUpgrades />}
        {tab === 2 && <CoreSuppressionSelector />}
      </Window.Content>
    </Window>
  );
};

const FacilityUpgrades = (props, context) => {
  const { act, data } = useBackend(context);
  const { Upgrade_points, is_admin } = data;

  return (
    <Section title="Master facility upgrade systems">
      {is_admin === 1 && (
        <Box mt="0.5em">
          <Button
            content={'ADMIN: Remove 1 LOB point'}
            color={'purple'}
            onClick={() => act('Change LOB Points', {
              LOB_amount: -1,
            })}
          />
          <Button
            content={'ADMIN: Remove 5 LOB points'}
            color={'purple'}
            onClick={() => act('Change LOB Points', {
              LOB_amount: -5,
            })}
          />
          <Button
            content={'ADMIN: Remove 10 LOB points'}
            color={'purple'}
            onClick={() => act('Change LOB Points', {
              LOB_amount: -10,
            })}
          />
          <Button
            content={'ADMIN: Add 1 LOB point'}
            color={'purple'}
            onClick={() => act('Change LOB Points', {
              LOB_amount: 1,
            })}
          />
          <Button
            content={'ADMIN: Add 5 LOB points'}
            color={'purple'}
            onClick={() => act('Change LOB Points', {
              LOB_amount: 5,
            })}
          />
          <Button
            content={'ADMIN: Add 10 LOB points'}
            color={'purple'}
            onClick={() => act('Change LOB Points', {
              LOB_amount: 10,
            })}
          />
        </Box>
      )}
      <LabeledList>
        <LabeledList.Item label="available LOB points: ">
          {Upgrade_points}
        </LabeledList.Item>
      </LabeledList>
      {/*
      All of the upgrade parts are basically the same,
      except they have different mapping variables so we can sort out categories
      Surelly there's a better way to do this
      */}
      <Box textColor="blue" mt="1em" ml="0.5em" fontSize="20px" nowrap>
        available unlockable bullets:
      </Box>
      <BulletUpgrades />

      <Box textColor="blue" mt="1em" ml="1em" fontSize="20px" nowrap>
        available bullet upgrades:
      </Box>
      <MoreBulletUpgrades />

      <Box textColor="blue" mt="1em" ml="1em" fontSize="20px" nowrap>
        available agent upgrades:
      </Box>
      <AgentUpgrades />

      <Box textColor="blue" mt="1em" ml="1em" fontSize="20px" nowrap>
        available abnormality cell upgrades:
      </Box>
      <AbnormalityUpgrades />

      <Box textColor="blue" mt="1em" ml="1em" fontSize="20px" nowrap>
        available uncategorized upgrades:
      </Box>
      <MiscUpgrades />
    </Section>
  );
};

const CoreSuppressionSelector = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    is_admin,
    current_suppression,
    available_suppressions,
    selected_core_name,
    selected_core_description,
    selected_core_goal,
    selected_core_reward,
    selected_core_color,
  } = data;

  if (current_suppression) {
    return (
      <Section minHeight="220px">
        {is_admin === 1 && (
          <Button
            content={'ADMIN: End core suppression'}
            color={'purple'}
            onClick={() => act('End Core Suppression')}
          />
        )}
        <Box textColor="red" textAlign="center">
          WARNING WARNING WARNING
          WARNING WARNING WARNING
          WARNING WARNING WARNING
        </Box>
        <NoticeBox color={selected_core_color} bold textAlign="center" fontSize="40px">
          {current_suppression} in progress!
        </NoticeBox>
        <Box textColor="red" textAlign="center">
          WARNING WARNING WARNING
          WARNING WARNING WARNING
          WARNING WARNING WARNING
        </Box>
      </Section>
    );
  }

  return (
    <Section title="Master core suppression systems">
      {is_admin === 1 && (
        <Box mt="0.5em">
          <Button
            content={'ADMIN: Unlock all core suppressions'}
            color={'purple'}
            onClick={() => act('Unlock All Cores')}
          />
          <Button
            content={'ADMIN: Disable all core suppressions'}
            color={'purple'}
            onClick={() => act('Disable Core Suppression')}
          />
        </Box>
      )}
      {available_suppressions.length > 0 && (
        <LabeledList>
          {available_suppressions.map(available_suppressions => (
            <LabeledList.Item
              key={available_suppressions.name}
              label={available_suppressions.name}
              buttons={
                <Button
                  content={'Choose core suppression'}
                  color={'green'}
                  onClick={() =>
                    act('Select Core Suppression', {
                      selected_core: available_suppressions.ref,
                    })}
                />
              }
            />
          ))}
        </LabeledList>
      )}
      {selected_core_name && (
        <LabeledList>
          <LabeledList.Item label="Selected core name: ">
            {selected_core_name}
          </LabeledList.Item>
          <LabeledList.Item label="Selected core description: ">
            {selected_core_description}
          </LabeledList.Item>
          <LabeledList.Item label="Selected core goal: ">
            {selected_core_goal}
          </LabeledList.Item>
          <LabeledList.Item label="Selected core reward: ">
            {selected_core_reward}
          </LabeledList.Item>
          <Button mt="1em" ml="0.5em"
            content={'Confirm core selection'}
            color={'green'}
            onClick={() => act('Activate Core Suppression')}
          />
        </LabeledList>
      )}
    </Section>
  );
};

const BulletUpgrades = (props, context) => {
  const { act, data } = useBackend(context);
  const { Upgrade_points, bullet_upgrades } = data;

  if (bullet_upgrades.length < 1) {
    return;
  }

  return (
    <LabeledList>
      {bullet_upgrades.map(bullet_upgrades => (
        <LabeledList.Item
          key={bullet_upgrades.name}
          label={bullet_upgrades.name}
          buttons={
            <Button
              content={
                bullet_upgrades.available === 1
                  ? 'Purchase the bullet for '
                  + bullet_upgrades.cost
                  + ' LOB points'
                  : 'UPGRADE PURCHASED'
              }
              color={
                Upgrade_points >= bullet_upgrades.cost
                && bullet_upgrades.available === 1
                  ? 'green'
                  : 'red'
              }
              onClick={() =>
                act('Buy Upgrade', {
                  selected_upgrade: bullet_upgrades.ref,
                })}
            />
          }
        />
      ))}
    </LabeledList>
  );
};

const MoreBulletUpgrades = (props, context) => {
  const { act, data } = useBackend(context);
  const { Upgrade_points, real_bullet_upgrades } = data;

  if (real_bullet_upgrades.length < 1) {
    return;
  }

  return (
    <LabeledList>
      {real_bullet_upgrades.map(real_bullet_upgrades => (
        <LabeledList.Item
          key={real_bullet_upgrades.name}
          label={real_bullet_upgrades.name}
          buttons={
            <Button
              content={
                real_bullet_upgrades.available === 1
                  ? 'Purchase the bullet upgrade for '
                  + real_bullet_upgrades.cost
                  + ' LOB points'
                  : 'UPGRADE PURCHASED'
              }
              color={
                Upgrade_points >= real_bullet_upgrades.cost
                && real_bullet_upgrades.available === 1
                  ? 'green'
                  : 'red'
              }
              onClick={() =>
                act('Buy Upgrade', {
                  selected_upgrade: real_bullet_upgrades.ref,
                })}
            />
          }
        />
      ))}
    </LabeledList>
  );
};

const AgentUpgrades = (props, context) => {
  const { act, data } = useBackend(context);
  const { Upgrade_points, agent_upgrades } = data;

  if (agent_upgrades.length < 1) {
    return;
  }

  return (
    <LabeledList>
      {agent_upgrades.map(agent_upgrades => (
        <LabeledList.Item
          key={agent_upgrades.name}
          label={agent_upgrades.name}
          buttons={
            <Button
              content={
                agent_upgrades.available === 1
                  ? 'Purchase the agent upgrade for '
                  + agent_upgrades.cost
                  + ' LOB points'
                  : 'UPGRADE PURCHASED'
              }
              color={
                Upgrade_points >= agent_upgrades.cost
                && agent_upgrades.available === 1
                  ? 'green'
                  : 'red'
              }
              onClick={() =>
                act('Buy Upgrade', {
                  selected_upgrade: agent_upgrades.ref,
                })}
            />
          }
        />
      ))}
    </LabeledList>
  );
};

const AbnormalityUpgrades = (props, context) => {
  const { act, data } = useBackend(context);
  const { Upgrade_points, abnormality_upgrades } = data;

  if (abnormality_upgrades.length < 1) {
    return;
  }

  return (
    <LabeledList>
      {abnormality_upgrades.map(abnormality_upgrades => (
        <LabeledList.Item
          key={abnormality_upgrades.name}
          label={abnormality_upgrades.name}
          buttons={
            <Button
              content={
                abnormality_upgrades.available === 1
                  ? 'Purchase the abnormality cell upgrade for '
                  + abnormality_upgrades.cost
                  + ' LOB points'
                  : 'UPGRADE PURCHASED'
              }
              color={
                Upgrade_points >= abnormality_upgrades.cost
                && abnormality_upgrades.available === 1
                  ? 'green'
                  : 'red'
              }
              onClick={() =>
                act('Buy Upgrade', {
                  selected_upgrade: abnormality_upgrades.ref,
                })}
            />
          }
        />
      ))}
    </LabeledList>
  );
};

const MiscUpgrades = (props, context) => {
  const { act, data } = useBackend(context);
  const { Upgrade_points, misc_upgrades } = data;

  if (misc_upgrades.length < 1) {
    return;
  }

  return (
    <LabeledList>
      {misc_upgrades.map(misc_upgrades => (
        <LabeledList.Item
          key={misc_upgrades.name}
          label={misc_upgrades.name}
          buttons={
            <Button
              content={
                misc_upgrades.available === 1
                  ? 'Purchase the upgrade for '
                  + misc_upgrades.cost
                  + ' LOB points'
                  : 'UPGRADE PURCHASED'
              }
              color={
                Upgrade_points >= misc_upgrades.cost
                && misc_upgrades.available === 1
                  ? 'green'
                  : 'red'
              }
              onClick={() =>
                act('Buy Upgrade', {
                  selected_upgrade: misc_upgrades.ref,
                })}
            />
          }
        />
      ))}
    </LabeledList>
  );
};
