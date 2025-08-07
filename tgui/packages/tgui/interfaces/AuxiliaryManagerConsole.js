// THIS IS A LOBOTOMYCORPORATION UI FILE

import { resolveAsset } from '../assets';
import { useBackend, useLocalState } from '../backend';
import { Box, Button, LabeledList, NoticeBox, Section, Tabs, Collapsible } from '../components';
import { Window } from '../layouts';

export const AuxiliaryManagerConsole = (props, context) => {
  const [tab, setTab] = useLocalState(context, 'tab', 1);

  return (
    <Window title="Auxiliary Managerial Console" width="850" height="600">
      <Window.Content>
        <Tabs>
          <Tabs.Tab
            icon="list"
            lineHeight="23px"
            selected={tab === 1}
            onClick={() => setTab(1)}>
            Bullet Upgrade System
          </Tabs.Tab>
          <Tabs.Tab
            icon="list"
            lineHeight="23px"
            selected={tab === 2}
            onClick={() => setTab(2)}>
            Facility Upgrade System
          </Tabs.Tab>
          <Tabs.Tab
            icon="list"
            lineHeight="23px"
            selected={tab === 3}
            onClick={() => setTab(3)}>
            Higher-up Specialization Upgrade System
          </Tabs.Tab>
          <Tabs.Tab
            icon="list"
            lineHeight="23px"
            selected={tab === 4}
            onClick={() => setTab(4)}>
            Core Suppression system
          </Tabs.Tab>
        </Tabs>
        {tab === 1 && <BulletFacilityUpgrades />}
        {tab === 2 && <FacilityUpgrades />}
        {tab === 3 && <SpecialUpgrades />}
        {tab === 4 && <CoreSuppressionSelector />}
      </Window.Content>
    </Window>
  );
};

const BulletFacilityUpgrades = (props, context) => {
  const { act, data } = useBackend(context);
  const { Upgrade_points, is_admin } = data;

  return (
    <Section title="Master bullet upgrade system">
      {is_admin === 1 && (
        <NoticeBox danger bold textAlign="center">
          !! Due to being adminned,
          your proximity and living checks are bypassed !!
        </NoticeBox>
      )}
      {is_admin === 1 && (
        <Box mt="0.5em" backgroundColor="purple">
          (ADMIN ONLY) Add/Subtract LOB points:
          <Button
            content={'-100'}
            color={'red'}
            onClick={() => act('Change LOB Points', {
              LOB_amount: -100,
            })}
          />
          <Button
            content={'-10'}
            color={'red'}
            onClick={() => act('Change LOB Points', {
              LOB_amount: -10,
            })}
          />
          <Button
            content={'-5'}
            color={'red'}
            onClick={() => act('Change LOB Points', {
              LOB_amount: -5,
            })}
          />
          <Button
            content={'-1'}
            color={'red'}
            onClick={() => act('Change LOB Points', {
              LOB_amount: -1,
            })}
          />
          <Button
            content={'+1'}
            color={'green'}
            onClick={() => act('Change LOB Points', {
              LOB_amount: 1,
            })}
          />
          <Button
            content={'+5'}
            color={'green'}
            onClick={() => act('Change LOB Points', {
              LOB_amount: 5,
            })}
          />
          <Button
            content={'+10'}
            color={'green'}
            onClick={() => act('Change LOB Points', {
              LOB_amount: 10,
            })}
          />
          <Button
            content={'+100'}
            color={'green'}
            onClick={() => act('Change LOB Points', {
              LOB_amount: 100,
            })}
          />
        </Box>
      )}
      <LabeledList>
        <LabeledList.Item
          label="available LOB points"
          buttons={
            <Button
              content={'Switch style to UI'}
              color={'blue'}
              onClick={() => act('Switch Style')}
            />
          }
        >
          {Upgrade_points}
        </LabeledList.Item>
      </LabeledList>

      {/*
      All of the upgrade parts are basically the same,
      except they have different mapping variables so we can sort out categories
      Surelly there's a better way to do this
      */}
      <BulletUpgrades />

      <MoreBulletUpgrades />
    </Section>
  );
};

const FacilityUpgrades = (props, context) => {
  const { act, data } = useBackend(context);
  const { Upgrade_points, is_admin } = data;

  return (
    <Section title="Master facility upgrade system">
      {is_admin === 1 && (
        <NoticeBox danger bold textAlign="center">
          !! Due to being adminned,
          your proximity and living checks are bypassed !!
        </NoticeBox>
      )}
      {is_admin === 1 && (
        <Box mt="0.5em" backgroundColor="purple">
          (ADMIN ONLY) Add/Subtract LOB points:
          <Button
            content={'-100'}
            color={'red'}
            onClick={() => act('Change LOB Points', {
              LOB_amount: -100,
            })}
          />
          <Button
            content={'-10'}
            color={'red'}
            onClick={() => act('Change LOB Points', {
              LOB_amount: -10,
            })}
          />
          <Button
            content={'-5'}
            color={'red'}
            onClick={() => act('Change LOB Points', {
              LOB_amount: -5,
            })}
          />
          <Button
            content={'-1'}
            color={'red'}
            onClick={() => act('Change LOB Points', {
              LOB_amount: -1,
            })}
          />
          <Button
            content={'+1'}
            color={'green'}
            onClick={() => act('Change LOB Points', {
              LOB_amount: 1,
            })}
          />
          <Button
            content={'+5'}
            color={'green'}
            onClick={() => act('Change LOB Points', {
              LOB_amount: 5,
            })}
          />
          <Button
            content={'+10'}
            color={'green'}
            onClick={() => act('Change LOB Points', {
              LOB_amount: 10,
            })}
          />
          <Button
            content={'+100'}
            color={'green'}
            onClick={() => act('Change LOB Points', {
              LOB_amount: 100,
            })}
          />
        </Box>
      )}
      <LabeledList>
        <LabeledList.Item
          label="available LOB points"
          buttons={
            <Button
              content={'Switch style to UI'}
              color={'blue'}
              onClick={() => act('Switch Style')}
            />
          }
        >
          {Upgrade_points}
        </LabeledList.Item>
      </LabeledList>

      {/*
      All of the upgrade parts are basically the same,
      except they have different mapping variables so we can sort out categories
      Surelly there's a better way to do this
      */}
      <AbnormalityUpgrades />

      <MiscUpgrades />
    </Section>
  );
};

const SpecialUpgrades = (props, context) => {
  const { act, data } = useBackend(context);
  const { Upgrade_points, is_admin } = data;

  return (
    <Section title="Master higher-up specialization upgrade system">
      {is_admin === 1 && (
        <NoticeBox danger bold textAlign="center">
          !! Due to being adminned,
          your proximity and living checks are bypassed !!
        </NoticeBox>
      )}
      {is_admin === 1 && (
        <Box mt="0.5em" backgroundColor="purple">
          (ADMIN ONLY) Add/Subtract LOB points:
          <Button
            content={'-100'}
            color={'red'}
            onClick={() => act('Change LOB Points', {
              LOB_amount: -100,
            })}
          />
          <Button
            content={'-10'}
            color={'red'}
            onClick={() => act('Change LOB Points', {
              LOB_amount: -10,
            })}
          />
          <Button
            content={'-5'}
            color={'red'}
            onClick={() => act('Change LOB Points', {
              LOB_amount: -5,
            })}
          />
          <Button
            content={'-1'}
            color={'red'}
            onClick={() => act('Change LOB Points', {
              LOB_amount: -1,
            })}
          />
          <Button
            content={'+1'}
            color={'green'}
            onClick={() => act('Change LOB Points', {
              LOB_amount: 1,
            })}
          />
          <Button
            content={'+5'}
            color={'green'}
            onClick={() => act('Change LOB Points', {
              LOB_amount: 5,
            })}
          />
          <Button
            content={'+10'}
            color={'green'}
            onClick={() => act('Change LOB Points', {
              LOB_amount: 10,
            })}
          />
          <Button
            content={'+100'}
            color={'green'}
            onClick={() => act('Change LOB Points', {
              LOB_amount: 100,
            })}
          />
        </Box>
      )}
      <LabeledList>
        <LabeledList.Item
          label="available LOB points"
          buttons={
            <Button
              content={'Switch style to UI'}
              color={'blue'}
              onClick={() => act('Switch Style')}
            />
          }
        >
          {Upgrade_points}
        </LabeledList.Item>
      </LabeledList>

      {/*
      All of the upgrade parts are basically the same,
      except they have different mapping variables so we can sort out categories
      Surelly there's a better way to do this
      */}
      <Lvl1Upgrades />

      <Lvl2Upgrades />
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
    selected_core_icon,
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
        <Box textColor="red" textAlign="center" fontFamily="Baskerville">
          WARNING WARNING WARNING
          WARNING WARNING WARNING
          WARNING WARNING WARNING
        </Box>
        <NoticeBox color={selected_core_color} bold textAlign="center" fontSize="40px" fontFamily="Baskerville">
          <img src={resolveAsset(selected_core_icon)} />
          {current_suppression} in progress!
          <img src={resolveAsset(selected_core_icon)} />
        </NoticeBox>
        <Box textColor="red" textAlign="center" fontFamily="Baskerville">
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
        <NoticeBox danger bold textAlign="center">
          !! Due to being adminned,
          your proximity and living checks are bypassed !!
        </NoticeBox>
      )}
      {is_admin === 1 && (
        <Box mt="0.5em">
          <Button
            content={'ADMIN: Unlock all core suppressions'}
            color={'purple'}
            onClick={() =>
              act('Unlock Core Suppressions', {
                core_unlock: 1,
              })}
          />
          <Button
            content={'ADMIN: Disable all core suppressions'}
            color={'purple'}
            onClick={() => act('Disable Core Suppression')}
          />
        </Box>
      )}
      {is_admin === 1 && (
        <Collapsible
          title="ADMIN: Select a specific core suppression to unlock"
          color="purple">
          <AllCores />
        </Collapsible>
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
      {available_suppressions.length === 0 && (
        <NoticeBox info bold textAlign="center" fontSize="40px" fontFamily="Baskerville">
          Core suppressions not available!
        </NoticeBox>
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

/**
 * Tons of copy paste down below
 */

const BulletUpgrades = (props, context) => {
  const { act, data } = useBackend(context);
  const { Upgrade_points, bullet_upgrades } = data;

  if (bullet_upgrades.length < 1) {
    return;
  }

  return (
    <>
      <Box textColor="blue" mt="1em" fontSize="20px" nowrap>
        Available unlockable bullets:
      </Box>
      <LabeledList>
        {bullet_upgrades.map(bullet_upgrades => (
          <LabeledList.Item
            key={bullet_upgrades.name}
            label={bullet_upgrades.name}
            buttons={
              <>
                <Button
                  content={bullet_upgrades.available === 1
                    ? 'Purchase the bullet for '
                    + bullet_upgrades.cost
                    + ' LOB points'
                    : 'UPGRADE PURCHASED'}
                  color={Upgrade_points >= bullet_upgrades.cost
                    && bullet_upgrades.available === 1
                    ? 'green'
                    : 'red'}
                  onClick={() => act('Buy Upgrade', {
                    selected_upgrade: bullet_upgrades.ref,
                  })} />
                <Button
                  content={"Info"}
                  color={"blue"}
                  onClick={() => act('Info', {
                    selected_upgrade: bullet_upgrades.ref,
                  })} />
              </>
            } />
        ))}
      </LabeledList>
    </>
  );
};

const MoreBulletUpgrades = (props, context) => {
  const { act, data } = useBackend(context);
  const { Upgrade_points, real_bullet_upgrades } = data;

  if (real_bullet_upgrades.length < 1) {
    return;
  }

  return (
    <>
      <Box textColor="blue" mt="1em" fontSize="20px" nowrap>
        Available bullet upgrades:
      </Box>
      <LabeledList>
        {real_bullet_upgrades.map(real_bullet_upgrades => (
          <LabeledList.Item
            key={real_bullet_upgrades.name}
            label={real_bullet_upgrades.name}
            buttons={
              <>
                <Button
                  content={real_bullet_upgrades.available === 1
                    ? 'Purchase the upgrade for '
                    + real_bullet_upgrades.cost
                    + ' LOB points'
                    : 'UPGRADE PURCHASED'}
                  color={Upgrade_points >= real_bullet_upgrades.cost
                    && real_bullet_upgrades.available === 1
                    ? 'green'
                    : 'red'}
                  onClick={() => act('Buy Upgrade', {
                    selected_upgrade: real_bullet_upgrades.ref,
                  })} />
                <Button
                  content={"Info"}
                  color={"blue"}
                  onClick={() => act('Info', {
                    selected_upgrade: real_bullet_upgrades.ref,
                  })} />
              </>
            } />
        ))}
      </LabeledList>
    </>
  );
};

const AbnormalityUpgrades = (props, context) => {
  const { act, data } = useBackend(context);
  const { Upgrade_points, abnormality_upgrades } = data;

  if (abnormality_upgrades.length < 1) {
    return;
  }

  return (
    <>
      <Box textColor="blue" mt="1em" fontSize="20px" nowrap>
        Available facility upgrades:
      </Box>
      <LabeledList>
        {abnormality_upgrades.map(abnormality_upgrades => (
          <LabeledList.Item
            key={abnormality_upgrades.name}
            label={abnormality_upgrades.name}
            buttons={
              <>
                <Button
                  content={abnormality_upgrades.available === 1
                    ? 'Purchase the upgrade for '
                    + abnormality_upgrades.cost
                    + ' LOB points'
                    : 'UPGRADE PURCHASED'}
                  color={Upgrade_points >= abnormality_upgrades.cost
                    && abnormality_upgrades.available === 1
                    ? 'green'
                    : 'red'}
                  onClick={() => act('Buy Upgrade', {
                    selected_upgrade: abnormality_upgrades.ref,
                  })} />
                <Button
                  content={"Info"}
                  color={"blue"}
                  onClick={() => act('Info', {
                    selected_upgrade: abnormality_upgrades.ref,
                  })} />
              </>
            } />
        ))}
      </LabeledList>
    </>
  );
};

const Lvl1Upgrades = (props, context) => {
  const { act, data } = useBackend(context);
  const { Upgrade_points, lvl1_upgrades } = data;

  if (lvl1_upgrades.length < 1) {
    return;
  }

  return (
    <>
      <Box textColor="blue" mt="1em" fontSize="20px" nowrap>
        Available tier 1 higher-up specialization upgrades:
      </Box>
      <LabeledList>
        {lvl1_upgrades.map(lvl1_upgrades => (
          <LabeledList.Item
            key={lvl1_upgrades.name}
            label={lvl1_upgrades.name}
            buttons={
              <>
                <Button
                  content={lvl1_upgrades.available === 1
                    ? 'Purchase the upgrade for '
                    + lvl1_upgrades.cost
                    + ' LOB points'
                    : 'UPGRADE PURCHASED'}
                  color={Upgrade_points >= lvl1_upgrades.cost
                    && lvl1_upgrades.available === 1
                    ? 'green'
                    : 'red'}
                  onClick={() => act('Buy Upgrade', {
                    selected_upgrade: lvl1_upgrades.ref,
                  })} />
                <Button
                  content={"Info"}
                  color={"blue"}
                  onClick={() => act('Info', {
                    selected_upgrade: lvl1_upgrades.ref,
                  })} />
              </>
            } />
        ))}
      </LabeledList>
    </>
  );
};

const Lvl2Upgrades = (props, context) => {
  const { act, data } = useBackend(context);
  const { Upgrade_points, lvl2_upgrades } = data;

  if (lvl2_upgrades.length < 1) {
    return;
  }

  return (
    <>
      <Box textColor="blue" mt="1em" fontSize="20px" nowrap>
        Available tier 2 higher-up specialization upgrades:
      </Box>
      <LabeledList>
        {lvl2_upgrades.map(lvl2_upgrades => (
          <LabeledList.Item
            key={lvl2_upgrades.name}
            label={lvl2_upgrades.name}
            buttons={
              <>
                <Button
                  content={lvl2_upgrades.available === 1
                    ? 'Purchase the upgrade for '
                    + lvl2_upgrades.cost
                    + ' LOB points'
                    : 'UPGRADE PURCHASED'}
                  color={Upgrade_points >= lvl2_upgrades.cost
                    && lvl2_upgrades.available === 1
                    ? 'green'
                    : 'red'}
                  onClick={() => act('Buy Upgrade', {
                    selected_upgrade: lvl2_upgrades.ref,
                  })} />
                <Button
                  content={"Info"}
                  color={"blue"}
                  onClick={() => act('Info', {
                    selected_upgrade: lvl2_upgrades.ref,
                  })} />
              </>
            } />
        ))}
      </LabeledList>
    </>
  );
};

const MiscUpgrades = (props, context) => {
  const { act, data } = useBackend(context);
  const { Upgrade_points, misc_upgrades } = data;

  if (misc_upgrades.length < 1) {
    return;
  }

  return (
    <>
      <Box textColor="blue" mt="1em" fontSize="20px" nowrap>
        Available uncategorized upgrades:
      </Box>
      <LabeledList>
        {misc_upgrades.map(misc_upgrades => (
          <LabeledList.Item
            key={misc_upgrades.name}
            label={misc_upgrades.name}
            buttons={
              <>
                <Button
                  content={misc_upgrades.available === 1
                    ? 'Purchase the upgrade for '
                    + misc_upgrades.cost
                    + ' LOB points'
                    : 'UPGRADE PURCHASED'}
                  color={Upgrade_points >= misc_upgrades.cost
                    && misc_upgrades.available === 1
                    ? 'green'
                    : 'red'}
                  onClick={() => act('Buy Upgrade', {
                    selected_upgrade: misc_upgrades.ref,
                  })} />
                <Button
                  content={"Info"}
                  color={"blue"}
                  onClick={() => act('Info', {
                    selected_upgrade: misc_upgrades.ref,
                  })} />
              </>
            } />
        ))}
      </LabeledList>
    </>
  );
};

const AllCores = (props, context) => {
  const { act, data } = useBackend(context);
  const { all_core_suppressions } = data;

  if (all_core_suppressions.length < 1) {
    return;
  }

  return (
    <LabeledList>
      {all_core_suppressions.map(all_core_suppressions => (
        <LabeledList.Item
          key={all_core_suppressions.name}
          label={all_core_suppressions.name}
          buttons={
            <Button
              content={'Add core suppression to the available cores pool'}
              color={'purple'}
              onClick={() =>
                act('Unlock Core Suppressions', {
                  core_unlock: all_core_suppressions.ref,
                })}
            />
          }
        />
      ))}
    </LabeledList>
  );
};
