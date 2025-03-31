import { useBackend, useSharedState } from '../backend'; // CORRECTED PATH & useSharedState
import {
  AnimatedNumber,
  Box, // Available in ChemMaster
  Button, // Available in ChemMaster
  Input, // Available in ChemMaster









  // Icon,    // Removed direct Icon usage for preview
  LabeledList, // ASSUMING Dropdown exists, **potential issue if not**
  NumberInput, // Available in ChemMaster
  Section, // Available in ChemMaster
  Table, // Basic Input likely exists
  TextArea
} from '../components'; // CORRECTED PATH
import { Window } from '../layouts'; // CORRECTED PATH for Window layout

// Helper function to check if a string is a valid hex color (Keep this)
const isValidHex = (color) => /^#([0-9A-F]{3}){1,2}$/i.test(color);

// Main Component using the Window layout
export const AugmentFabricator = (props, context) => {
  const { data } = useBackend(context);
  // Use a state variable to control page display within the single component
  const [page, setPage] = useSharedState(context, 'page', 'template'); // 'template' or 'effects'

  return (
    <Window
      title="Augment Fabricator"
      width={700} // Adjusted width
      height={600} // Adjusted height
    >
      <Window.Content scrollable> {/* Added scrollable */}
        {page === 'template' && <TemplatePage setPage={setPage} /> }
        {page === 'effects' && <EffectsPage setPage={setPage} />}
      </Window.Content>
    </Window>
  );
};

// Component for Page 1: Template & Flavor Selection
const TemplatePage = (props, context) => {
  const { setPage } = props; // Function to change page
  const { act, data } = useBackend(context);

  // State Hooks using useSharedState
  const [selectedFormName, setSelectedFormName] = useSharedState(context, 'form', null);
  const [selectedRank, setSelectedRank] = useSharedState(context, 'rank', 1);
  const [augName, setAugName] = useSharedState(context, 'augName', '');
  const [augDesc, setAugDesc] = useSharedState(context, 'augDesc', '');
  const [primaryColor, setPrimaryColor] = useSharedState(context, 'primaryColor', '#FFFFFF');
  const [secondaryColor, setSecondaryColor] = useSharedState(context, 'secondaryColor', '#CCCCCC');

  const {
    forms = [],
    maxRank = 5,
    rankAttributeReqs = [0, 0, 0, 0, 0],
    currencySymbol = 'ahn',
  } = data;

  const selectedForm = forms.find(f => f.name === selectedFormName) || null;
  const baseCost = selectedForm ? selectedForm.base_cost * selectedRank : 0;
  const baseEp = selectedForm ? selectedForm.base_ep * selectedRank : 0;

  // Prepare options for Dropdown (assuming it exists)
  const formOptions = forms.map(f => ({
    key: f.name, // Using name as key, ensure names are unique
    value: f.name,
    content: `${f.name} (${f.base_cost} ${currencySymbol}, ${f.base_ep} Base EP)`,
  }));

  return (
    <Box> {/* Using Box as the main container instead of Flex */}
      <Section title="Template Selection">
        <LabeledList>
          <LabeledList.Item label="Form">
            {forms.map(f => (
              <Button
                key={f.name}
                selected={selectedFormName === f.name} // Highlight selected
                onClick={() => setSelectedFormName(f.name)}
                mr={1} // Add some margin between buttons
                content={`${f.name} (${f.base_cost} ${currencySymbol}, ${f.base_ep} EP)`}
              />
            ))}
          </LabeledList.Item>
          <LabeledList.Item label="Rank">
            <NumberInput
              value={selectedRank}
              minValue={1}
              maxValue={maxRank}
              step={1}
              width="50px"
              onChange={(e, value) => setSelectedRank(value)}
            />
            <Box inline ml={2}>
              (Requires Attribute: {rankAttributeReqs[selectedRank - 1] || 0}+)
            </Box>
          </LabeledList.Item>
        </LabeledList>
        {selectedForm && (
          <Box mt={1}>
            {/* Manual Divider */}
            <Box borderBottom={1} borderColor="rgba(255, 255, 255, 0.1)" my={1} />
            <Box mt={1}>Base Cost: <AnimatedNumber value={baseCost} /> {currencySymbol}</Box>
            <Box>Base EP: <AnimatedNumber value={baseEp} /></Box>
          </Box>
        )}
      </Section>

      <Section title="Flavor & Appearance">
        <LabeledList>
          <LabeledList.Item label="Augment Name">
            <Input // Assuming basic Input component works
              value={augName}
              placeholder="E.g., 'My Awesome Arm'"
              width="100%"
              onInput={(e, value) => setAugName(value)}
            />
          </LabeledList.Item>
          <LabeledList.Item label="Description">
             {/* ** POTENTIAL ISSUE: TextArea component existence/props ** */}
            <TextArea // Assuming TextArea exists
              value={augDesc}
              placeholder="A brief description of the augment."
              width="100%"
              height="60px" // Check if height prop works, might need CSS
              onInput={(e, value) => setAugDesc(value)}
            />
          </LabeledList.Item>
          <LabeledList.Item label="Primary Color">
            <Input
              value={primaryColor}
              width="100px"
              placeholder="#RRGGBB"
              onInput={(e, value) => setPrimaryColor(value)}
            />
            {/* Simple Box for color preview */}
            <Box inline width="20px" height="20px" ml={1} backgroundColor={isValidHex(primaryColor) ? primaryColor : 'transparent'} style={{ border: '1px solid grey' }} />
          </LabeledList.Item>
          <LabeledList.Item label="Secondary Color">
            <Input
              value={secondaryColor}
              width="100px"
              placeholder="#RRGGBB"
              onInput={(e, value) => setSecondaryColor(value)}
            />
            <Box inline width="20px" height="20px" ml={1} backgroundColor={isValidHex(secondaryColor) ? secondaryColor : 'transparent'} style={{ border: '1px solid grey' }} />
          </LabeledList.Item>
        </LabeledList>
      </Section>

      <Section title="Preview">
         <Box textAlign="center">
            {/* Placeholder Box instead of Icon */}
            <Box
              m="auto"
              width="48px"
              height="48px"
              lineHeight="48px" // Center text vertically
              backgroundColor={isValidHex(primaryColor) ? primaryColor : '#444'}
              color={isValidHex(secondaryColor) ? secondaryColor : '#ccc'}
              style={{ border: `2px solid ${isValidHex(secondaryColor) ? secondaryColor : '#888'}` }}
            >
                {selectedForm ? selectedForm.name.substring(0, 3) : 'N/A'}
            </Box>
            <Box mt={1}>
              {selectedForm ? `${augName || selectedForm.name} (Rank ${selectedRank})` : 'Select Form'}
            </Box>
            <Box color="label" fontSize="small">
              Colors: {primaryColor} / {secondaryColor}
            </Box>
         </Box>
      </Section>

      {/* Navigation Button */}
       {/* Manual Divider */}
      <Box borderTop={1} borderColor="rgba(255, 255, 255, 0.1)" mt={1} pt={1} textAlign="right">
        <Button
          icon="arrow-right"
          content="Select Effects"
          disabled={!selectedFormName}
          onClick={() => setPage('effects')}
          // Removed fluid, manage alignment with parent Box
        />
      </Box>
    </Box>
  );
};

// --- Updated EffectsPage component with "Properties" column ---
const EffectsPage = (props, context) => {
  const { setPage } = props;
  const { act, data } = useBackend(context);

  // State Hooks (Keep these)
  const [selectedFormName] = useSharedState(context, 'form');
  const [selectedRank] = useSharedState(context, 'rank', 1);
  const [augName] = useSharedState(context, 'augName', '');
  const [primaryColor] = useSharedState(context, 'primaryColor', '#FFFFFF');
  const [secondaryColor] = useSharedState(context, 'secondaryColor', '#CCCCCC');
  const [augDesc] = useSharedState(context, 'augDesc', '');
  const [selectedEffects, setSelectedEffects] = useSharedState(context, 'selectedEffects', []); // Array of effect IDs

  const {
    forms = [],
    effects = [],
    currencySymbol = 'ahn',
  } = data;

  // Calculations (Keep these)
  const selectedForm = forms.find(f => f.name === selectedFormName) || null;
  const baseCost = selectedForm ? selectedForm.base_cost * selectedRank : 0;
  const baseEp = selectedForm ? selectedForm.base_ep * selectedRank : 0;

  const selectedEffectsData = selectedEffects.map(effectId => {
    return effects.find(e => e.id === effectId);
  }).filter(e => e);

  const currentEpCost = selectedEffectsData.reduce((sum, effect) => sum + effect.ep_cost, 0);
  const currentEffectsCost = selectedEffectsData.reduce((sum, effect) => sum + effect.ahn_cost, 0);

  const remainingEp = baseEp - currentEpCost;
  const totalCost = baseCost + currentEffectsCost;

  // Event Handlers (Keep these)
  const handleAddEffect = (effectToAdd) => {
    const isRepeatable = effectToAdd.notes?.includes('[Repeatable]');
    const alreadyAdded = selectedEffects.includes(effectToAdd.id);
    if (!isRepeatable && alreadyAdded) { return; }
    if (effectToAdd.ep_cost <= remainingEp) {
      setSelectedEffects([...selectedEffects, effectToAdd.id]);
    }
  };
  const handleRemoveEffect = (indexToRemove) => {
    setSelectedEffects(selectedEffects.filter((_, index) => index !== indexToRemove));
  };
  const handleFabricate = () => {
    if (!selectedFormName || !augName.trim() || !isValidHex(primaryColor) || !isValidHex(secondaryColor) || remainingEp < 0) {
      alert("Please ensure Form, Name, Colors are set correctly and you have non-negative remaining EP.");
      return;
    }
    const config = {
      form: selectedFormName, rank: selectedRank, name: augName, description: augDesc,
      primaryColor: primaryColor, secondaryColor: secondaryColor, selectedEffects: selectedEffects,
    };
    act('fabricate', { config: JSON.stringify(config) });
  };

  return (
    <Box>
      {/* Top Info Bar (No changes) */}
      <Section>
         <Box display="flex" justifyContent="space-between" alignItems="center">
          <Box>
            Total Cost: <AnimatedNumber value={totalCost} /> {currencySymbol}
          </Box>
          <Box textAlign="right">
            <Box color={remainingEp < 0 ? 'bad' : 'good'}>
              EP: <AnimatedNumber value={remainingEp} /> / <AnimatedNumber value={baseEp} />
            </Box>
          </Box>
        </Box>
      </Section>
      <Box borderBottom={1} borderColor="rgba(255, 255, 255, 0.1)" my={1} />

      {/* Main Content Area */}
      <Box display="flex" height="calc(100% - 120px)">

        {/* Available Effects Column */}
        <Box flexBasis="50%" pr={1} overflowY="auto">
          <Section title="Available Effects">
            <Table>
              {/* Add Properties cell to header row */}
              <Table.Row header>
                <Table.Cell>Effect</Table.Cell>
                <Table.Cell collapsing>Properties</Table.Cell> {/* New Column Header */}
                <Table.Cell collapsing textAlign="right">Cost</Table.Cell>
                <Table.Cell collapsing textAlign="right">EP</Table.Cell>
                <Table.Cell collapsing>Action</Table.Cell>
              </Table.Row>
              {/* Map for available effects */}
              {!effects || effects.length === 0 ? (
                  /* Adjust colSpan */
                  <Table.Row><Table.Cell colSpan={5}>No effects available.</Table.Cell></Table.Row>
                ) : (
                  effects.map(effect => {
                  if (!effect || !effect.id || !effect.name) {
                      console.error("Skipping invalid effect object:", effect);
                      return null;
                  }

                  // Determine properties from notes
                  const isRepeatable = effect.notes?.includes('Repeatable');
                  // Check for negative EP cost as indicator for negative property
                  // OR check for a specific note like '[Negative]' if you prefer that
                  const isNegative = effect.ep_cost < 0 || effect.notes?.includes('Negative');

                  const canAfford = effect.ep_cost <= remainingEp;
                  const alreadyAdded = selectedEffects.includes(effect.id);
                  const isDisabled = !canAfford || (alreadyAdded && !isRepeatable);

                  return (
                    <Table.Row key={effect.id}>
                      {/* Effect Cell (Removed notes display) */}
                      <Table.Cell>
                        <Box title={effect.desc || ''}> {/* Put desc in title */}
                          {effect.name}
                        </Box>
                        <Box color="label" fontSize="small">{effect.desc || ''}</Box>
                      </Table.Cell>

                      {/* New Properties Cell */}
                      <Table.Cell collapsing>
                        {isRepeatable && (
                          <Box color="good" title="This effect can be applied multiple times.">Repeatable</Box>
                        )}
                        {isNegative && (
                          <Box color="bad" title="This effect has potential downsides but grants EP.">Negative</Box>
                        )}
                        {!isRepeatable && !isNegative && (
                          <Box color="label">-</Box> // Placeholder if no properties
                        )}
                      </Table.Cell>

                      {/* Cost Cell */}
                      <Table.Cell collapsing textAlign="right">{effect.ahn_cost ?? 'N/A'} {currencySymbol}</Table.Cell>

                      {/* EP Cell */}
                      <Table.Cell collapsing textAlign="right" color={effect.ep_cost > 0 ? 'bad' : (effect.ep_cost < 0 ? 'good' : 'label')}>
                          {effect.ep_cost > 0 ? `-${effect.ep_cost}` : (effect.ep_cost < 0 ? `+${Math.abs(effect.ep_cost)}` : '0')}
                      </Table.Cell>

                      {/* Action Cell */}
                      <Table.Cell collapsing>
                        <Button
                          icon="plus"
                          title={isDisabled && !canAfford ? "Not enough EP" : (isDisabled ? "Cannot add again" : "Add Effect")}
                          disabled={isDisabled}
                          onClick={() => handleAddEffect(effect)}
                        />
                      </Table.Cell>
                    </Table.Row>
                  );
                })
                )}
            </Table>
          </Section>
        </Box>

        {/* Selected Effects Column (No changes needed here) */}
        <Box flexBasis="50%" pl={1} overflowY="auto">
          <Section title="Selected Effects">
            {selectedEffects.length === 0 ? (
              <Box color="label" textAlign="center" mt={2}>No effects added yet.</Box>
            ) : (
              <Table>
                <Table.Row header>
                  <Table.Cell>Effect</Table.Cell>
                  <Table.Cell collapsing textAlign="right">EP</Table.Cell>
                  <Table.Cell collapsing>Action</Table.Cell>
                </Table.Row>
                {selectedEffects.map((effectId, index) => {
                  const effect = effects.find(e => e.id === effectId);
                  if (!effect) return (
                      <Table.Row key={`missing-${index}`}>
                          <Table.Cell colSpan={3} color="bad">Error: Effect data missing for ID {effectId}</Table.Cell>
                      </Table.Row>
                  );
                  return (
                    <Table.Row key={`${effectId}-${index}`}>
                      <Table.Cell>
                        {effect.name}
                      </Table.Cell>
                      <Table.Cell collapsing textAlign="right" color={effect.ep_cost > 0 ? 'bad' : (effect.ep_cost < 0 ? 'good' : 'label')}>
                        {effect.ep_cost > 0 ? `-${effect.ep_cost}` : (effect.ep_cost < 0 ? `+${Math.abs(effect.ep_cost)}` : '0')}
                      </Table.Cell>
                      <Table.Cell collapsing>
                        <Button
                          icon="minus"
                          title="Remove Effect"
                          onClick={() => handleRemoveEffect(index)}
                          color="bad"
                        />
                      </Table.Cell>
                    </Table.Row>
                  );
                })}
              </Table>
            )}
          </Section>
        </Box>
      </Box>

      {/* Bottom Buttons (No changes) */}
      <Box borderTop={1} borderColor="rgba(255, 255, 255, 0.1)" mt={1} pt={1} display="flex" justifyContent="space-between">
        <Button
          icon="arrow-left"
          content="Back to Template"
          onClick={() => setPage('template')}
        />
        <Button
          icon="cog"
          content="Fabricate"
          color="good"
          disabled={remainingEp < 0 || !selectedFormName || !augName.trim()}
          onClick={handleFabricate}
        />
      </Box>
    </Box>
  );
};
