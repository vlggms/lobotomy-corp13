import { useBackend, useSharedState } from '../backend';
import {
  AnimatedNumber,
  Box,
  Button,
  Flex,
  Input,
  LabeledList,
  NoticeBox,
  NumberInput,
  Section,
  Table,
  TextArea,
} from '../components';
import { Window } from '../layouts';

const isValidHex = color => /^#([0-9A-F]{3}){1,2}$/i.test(color);

export const AugmentFabricator = (props, context) => {
  const { data = {} } = useBackend(context);
  const [page, setPage] = useSharedState(context, 'page', 'template');
  const hasLoaded = data && data.forms && Array.isArray(data.forms);

  return (
    <Window
      title="Augment Fabricator"
      width={700}
      height={650}>
      <Window.Content scrollable>
        {!hasLoaded ? (<NoticeBox>Loading configuration...</NoticeBox>) : (
          <>
            {page === 'template' && <TemplatePage setPage={setPage} /> }
            {/* Pass context to EffectsPage if it uses useBackend/useSharedState */}
            {page === 'effects' && <EffectsPage setPage={setPage} context={context} />}
          </>
        )}
      </Window.Content>
    </Window>
  );
};

// Page 1: Template & Flavor (RESTORED)
const TemplatePage = (props, context) => {
  const { setPage } = props;
  const { act, data } = useBackend(context);

  // State Hooks
  const [selectedFormId, setSelectedFormId] = useSharedState(context, 'formId', null);
  const [selectedRank, setSelectedRank] = useSharedState(context, 'rank', 1);
  const [augName, setAugName] = useSharedState(context, 'augName', '');
  const [augDesc, setAugDesc] = useSharedState(context, 'augDesc', '');
  const [primaryColor, setPrimaryColor] = useSharedState(context, 'primaryColor', '#FFFFFF');
  const [secondaryColor, setSecondaryColor] = useSharedState(context, 'secondaryColor', '#CCCCCC');

  // Destructure data
  const {
    forms = [], maxRank = 5, rankAttributeReqs = [],
    currencySymbol = '?', previewIconBase64 = null,
  } = data;

  // Find selected form
  const selectedForm = forms.find(f => f.id === selectedFormId) || null;
  const currentRank = selectedRank || 1;

  // Calculations
  const baseCost = selectedForm ? (selectedForm.base_cost || 0) * currentRank : 0;
  const baseEp = selectedForm ? (selectedForm.base_ep || 0) * currentRank : 0;
  const rankReq = (rankAttributeReqs?.length > currentRank - 1)
    ? (rankAttributeReqs[currentRank - 1] || 0) : 0;

  // Helper function to request preview update
  const requestPreviewUpdate = (formId, pColor, sColor) => {
    // Pass validated colors to the backend action
    if (formId && isValidHex(pColor) && isValidHex(sColor)) {
      act('get_preview_icon', {
        formId: formId,
        primaryColor: pColor,
        secondaryColor: sColor,
      });
    }
    // If inputs are invalid, the backend should handle returning null preview data
  };

  // Form Button Handler
  const handleFormSelect = newFormId => {
    setSelectedFormId(newFormId);
    requestPreviewUpdate(newFormId, primaryColor, secondaryColor);
  };

  // Rank Change Handler (No useCallback)
  const handleRankChange = (e, value) => {
    const newRank = Math.max(1, Math.min(value || 1, maxRank || 5));
    setSelectedRank(newRank);
  };

  // Color Input Handlers
  const handlePrimaryColorChange = (e, value) => {
    // Allow empty input for deletion, but prefix with # if needed
    const newColor = value && value.length > 0 && !value.startsWith('#') ? '#' + value : value;
    setPrimaryColor(newColor);
    // Pass the potentially invalid color for validation check inside requestPreviewUpdate
    requestPreviewUpdate(selectedFormId, newColor, secondaryColor);
  };

  const handleSecondaryColorChange = (e, value) => {
    const newColor = value && value.length > 0 && !value.startsWith('#') ? '#' + value : value;
    setSecondaryColor(newColor);
    requestPreviewUpdate(selectedFormId, primaryColor, newColor);
  };

  return (
    <Box>
      {/* Template Selection Section */}
      <Section title="Template Selection">
        <LabeledList>
          <LabeledList.Item label="Form">
            {forms.length === 0 ? (
              <Box color="label">No forms available.</Box>
            ) : forms.map(f => {
              // Ensure checks for valid data before rendering button
              if (!f || !f.id) return null;
              const formName = f.name || 'Unnamed Form';
              const formDesc = f.desc || formName;
              const formStats = `(${(f.base_cost || 0)} ${currencySymbol}, ${(f.base_ep || 0)} EP)`;
              return (
                <Button
                  key={f.id}
                  selected={selectedFormId === f.id}
                  onClick={() => handleFormSelect(f.id)}
                  mr={1} // Margin between buttons
                  content={`${formName} ${formStats}`}
                  tooltip={formDesc} />
              );
            })}
          </LabeledList.Item>
          <LabeledList.Item label="Rank">
            <NumberInput
              value={currentRank}
              minValue={1}
              maxValue={maxRank}
              step={1}
              width="50px"
              onChange={handleRankChange} />
            <Box inline ml={2}>
              {rankReq > 0 && `(Req: ${rankReq}+ Attr)`}
            </Box>
          </LabeledList.Item>
        </LabeledList>
        {/* Conditional render for Cost/EP details */}
        {selectedForm && (
          <Box mt={1}>
            <Box borderBottom={1} borderColor="rgba(255, 255, 255, 0.1)" my={1} />
            {/* Render direct values - ensure baseCost/baseEp are numbers */}
            <Box mt={1}>Base Cost: {Number(baseCost) || 0} {currencySymbol}</Box>
            <Box>Base EP: {Number(baseEp) || 0}</Box>
            <Box color="label" fontSize="small">{selectedForm.desc || 'No description.'}</Box>
          </Box>
        )}
      </Section>

      {/* Flavor & Appearance Section */}
      <Section title="Flavor & Appearance">
        <Flex>
          {/* Left Column: Inputs */}
          <Flex.Item grow={1} mr={2}>
            <LabeledList>
              <LabeledList.Item label="Augment Name">
                <Input
                  value={augName}
                  onInput={(e, value) => setAugName(value)} // Direct state update
                  width="100%"
                  maxLength={64} // Restore attributes
                  placeholder="E.g., 'My Awesome Arm'" />
              </LabeledList.Item>
              <LabeledList.Item label="Description">
                <TextArea
                  value={augDesc}
                  onInput={(e, value) => setAugDesc(value)} // Direct state update
                  width="100%"
                  height="60px" // Restore attributes
                  maxLength={256}
                  placeholder="A brief description..." />
              </LabeledList.Item>
              <LabeledList.Item label="Primary Color">
                <Input
                  value={primaryColor}
                  onInput={handlePrimaryColorChange} // Use specific handler
                  width="100px" // Restore attributes
                  placeholder="#RRGGBB"
                  maxLength={7}
                  // Style for validation feedback
                  style={{ borderLeft: `5px solid ${isValidHex(primaryColor) ? primaryColor : 'red'}` }} />
                {/* Color Swatch */}
                <Box inline width="20px" height="20px" ml={1} backgroundColor={isValidHex(primaryColor) ? primaryColor : 'transparent'} style={{ border: '1px solid grey', verticalAlign: 'middle' }} />
                {/* Invalid Hex Message */}
                {!isValidHex(primaryColor) && primaryColor && primaryColor.length > 0 && <Box inline ml={1} color="bad">Invalid Hex</Box>}
              </LabeledList.Item>
              <LabeledList.Item label="Secondary Color">
                <Input
                  value={secondaryColor}
                  onInput={handleSecondaryColorChange} // Use specific handler
                  width="100px" // Restore attributes
                  placeholder="#RRGGBB"
                  maxLength={7}
                  // Style for validation feedback
                  style={{ borderLeft: `5px solid ${isValidHex(secondaryColor) ? secondaryColor : 'red'}` }} />
                {/* Color Swatch */}
                <Box inline width="20px" height="20px" ml={1} backgroundColor={isValidHex(secondaryColor) ? secondaryColor : 'transparent'} style={{ border: '1px solid grey', verticalAlign: 'middle' }} />
                {/* Invalid Hex Message */}
                {!isValidHex(secondaryColor) && secondaryColor && secondaryColor.length > 0 && <Box inline ml={1} color="bad">Invalid Hex</Box>}
              </LabeledList.Item>
            </LabeledList>
          </Flex.Item>

          {/* Right Column: Preview */}

          <Flex.Item shrink={0} basis="120px" textAlign="center">
            <Box mb={1} color="label">Preview:</Box>
            {/* Container Box - SQUARE */}
            <Box
              m="auto"
              width="64px" // Fixed SQUARE width
              height="64px" // Fixed SQUARE height
              backgroundColor="#222"
              // Remove flex centering, as image will now fill the box
              // display: 'flex',
              // alignItems: 'center',
              // justifyContent: 'center',
              style={{
                border: '1px solid #555',
                // imageRendering: 'pixelated', // Apply to inner img if needed
                overflow: 'hidden', // Clip anything overflowing
              }}>
              {/* Conditionally render the image using Box as="img" OR the placeholder */}
              {(previewIconBase64 && typeof previewIconBase64 === 'string') ? (
                <Box
                  key={previewIconBase64.substring(0, 20)}
                  as="img"
                  src={`data:image/png;base64,${previewIconBase64}`}
                  alt="Augment Preview"
                  title="Augment Preview"
                  style={{
                    // --- FORCE size to 100% of container ---
                    width: '100%',
                    height: '100%',
                    // --- END FORCE size ---

                    // Pixelation styles
                    imageRendering: 'pixelated',
                    '-ms-interpolation-mode': 'nearest-neighbor',

                    display: 'block', // Good practice for images filling space
                  }} />
              ) : (
              // Placeholder Box - needs centering if flex is removed from parent
                <Box
                  width="100%" height="100%" display="flex"
                  alignItems="center" justifyContent="center"
                  color="label" fontSize="small">
                  {selectedFormId ? 'Loading...' : 'Select Form'}
                </Box>
              )}
            </Box>
            {/* Preview Text (remains the same) */}
            <Box mt={1} fontSize="small">
              {selectedForm ? `${augName || selectedForm.name || 'Unnamed'} (R${currentRank})` : 'Select Form'}
            </Box>
          </Flex.Item>
        </Flex>
      </Section>

      {/* Navigation Button */}
      <Box borderTop={1} borderColor="rgba(255, 255, 255, 0.1)" mt={2} pt={1} textAlign="right">
        <Button
          icon="arrow-right"
          content="Select Effects"
          disabled={!selectedFormId} // Disable based on ID
          onClick={() => setPage('effects')} />
      </Box>
    </Box>
  );
};

// --- EffectsPage component (UPDATED to use formId) ---
const EffectsPage = (props, context) => {
  const { setPage } = props;
  const { act, data } = useBackend(context);

  // --- UPDATED: Read form ID ---
  const [selectedFormId] = useSharedState(context, 'formId');
  // Keep other shared state hooks
  const [selectedRank] = useSharedState(context, 'rank', 1);
  const [augName] = useSharedState(context, 'augName', '');
  const [augDesc] = useSharedState(context, 'augDesc', '');
  const [primaryColor] = useSharedState(context, 'primaryColor', '#FFFFFF');
  const [secondaryColor] = useSharedState(context, 'secondaryColor', '#CCCCCC');
  const [selectedEffects, setSelectedEffects] = useSharedState(context, 'selectedEffects', []); // Array of effect IDs

  const {
    forms = [],
    effects = [],
    currencySymbol = 'ahn',
  } = data;

  // --- UPDATED: Find form by ID ---
  const selectedForm = forms.find(f => f.id === selectedFormId) || null;
  const baseCost = selectedForm ? selectedForm.base_cost * selectedRank : 0;
  const baseEp = selectedForm ? selectedForm.base_ep + (selectedRank - 1) * 2 : 0;

  // Calculations remain the same (selectedCounts, currentEpCost, etc.)
  const selectedCounts = selectedEffects.reduce((counts, effectId) => {
    counts[effectId] = (counts[effectId] || 0) + 1;
    return counts;
  }, {});
  const selectedEffectsData = selectedEffects.map(effectId => {
    return effects.find(e => e.id === effectId);
  }).filter(e => e);

  const currentEpCost = selectedEffectsData.reduce((sum, effect) => sum + (effect?.ep_cost || 0), 0); // Add safety check for effect
  const currentNegEpCost = selectedEffectsData.reduce((sum, effect) => sum + (effect?.ep_cost < 0 ? effect?.ep_cost : 0), 0);
  const currentEffectsCost = selectedEffectsData.reduce((sum, effect) => sum + (effect?.current_ahn_cost || 0), 0);
  const remainingEp = baseEp - currentEpCost;
  const remainingNegEp = baseEp + currentNegEpCost;
  const totalCost = baseCost + currentEffectsCost;

  // Event Handlers (handleAddEffect, handleRemoveEffect remain the same)
  const handleAddEffect = effectToAdd => {
    if (!effectToAdd) return;
    if ((effectToAdd.ep_cost > 0 && effectToAdd.ep_cost <= remainingEp) || (effectToAdd.ep_cost < 0 && -effectToAdd.ep_cost <= remainingNegEp)) {
      setSelectedEffects([...selectedEffects, effectToAdd.id]);
    }
  };
  const handleRemoveEffect = indexToRemove => {
    setSelectedEffects(selectedEffects.filter((_, index) => index !== indexToRemove));
  };

  const handleFabricate = () => {
    // --- UPDATED: Check form ID ---
    if (!selectedFormId || remainingEp < 0) {
      // Add more user-friendly feedback if possible (e.g., NoticeBox or dedicated message area)
      alert('Please ensure a Form is selected and you have non-negative remaining EP.');
      return;
    }
    // Optional: Check if name is required, depends on game design
    if (!augName.trim()) {
      // alert("Please provide an Augment Name.");
      // return;
    }
    // Check colors are valid before sending
    if (!isValidHex(primaryColor) || !isValidHex(secondaryColor)) {
      alert('Please ensure Primary and Secondary colors are valid hex codes (e.g., #FFFFFF).');
      return;
    }

    const config = {
      form: selectedFormId, // --- SEND ID ---
      rank: selectedRank,
      name: augName.trim() || selectedForm?.name || 'Unnamed Augment', // Use form name as fallback if blank
      description: augDesc.trim(),
      primaryColor: primaryColor,
      secondaryColor: secondaryColor,
      selectedEffects: selectedEffects, // Send the list of IDs
    };
    act('fabricate', { config: JSON.stringify(config) });
  };

  // --- RENDER LOGIC ---
  // (Mostly the same, just ensure selectedForm is checked correctly)
  return (
    <Box>
      {/* Top Info Bar */}
      <Section>
        <Box display="flex" justifyContent="space-between" alignItems="center">
          <Box>
            Total Cost: <AnimatedNumber value={totalCost} /> {currencySymbol}
            {/* Optional: Show base cost if different */}
            {totalCost !== (baseCost + selectedEffectsData.reduce((sum, effect) => sum + (effect?.ahn_cost || 0), 0)) && (
              <Box inline ml={1} color="label" fontSize="small">
                (Base: {baseCost + selectedEffectsData.reduce((sum, effect) => sum + (effect?.ahn_cost || 0), 0)})
              </Box>
            )}
          </Box>
          <Box textAlign="right">
            <Box color={remainingEp < 0 ? 'bad' : 'good'}>
              EP: <AnimatedNumber value={remainingEp} /> / {baseEp} {/* Show static base EP */}
            </Box>
          </Box>
        </Box>
      </Section>
      <Box borderBottom={1} borderColor="rgba(255, 255, 255, 0.1)" my={1} />

      {/* Main Content Area */}
      {/* Flex container for columns */}
      <Box display="flex" height="calc(100% - 120px)"> {/* Adjust height based on surrounding elements */}

        {/* Available Effects Column */}
        <Box flexBasis="50%" pr={1} overflowY="auto" mr={1}> {/* Added margin right */}
          <Section title="Available Effects">
            <Table>
              {/* Header Row */}
              <Table.Row header>
                <Table.Cell>Effect</Table.Cell>
                <Table.Cell collapsing>Properties</Table.Cell>
                <Table.Cell collapsing textAlign="right">Cost</Table.Cell>
                <Table.Cell collapsing textAlign="right">EP</Table.Cell>
                <Table.Cell collapsing>Action</Table.Cell>
              </Table.Row>
              {/* Effects Rows */}
              {!effects || effects.length === 0 ? (
                <Table.Row><Table.Cell colSpan={5}>No effects available.</Table.Cell></Table.Row>
              ) : (
                effects.map(effect => {
                  // Safety check for effect data
                  if (!effect || !effect.id || !effect.name) {
                    console.error('Skipping invalid effect object:', effect);
                    return null;
                  }

                  const isNegative = effect.ep_cost < 0;
                  const maxRepeats = Number(effect.repeatable) || 0;
                  const isRepeatable = maxRepeats > 0;
                  const currentCount = selectedCounts[effect.id] || 0;
                  const remainingRepeats = maxRepeats - currentCount;

                  const canAfford = (effect.ep_cost > 0 && effect.ep_cost <= remainingEp) || (effect.ep_cost < 0 && -effect.ep_cost <= remainingNegEp);
                  const maxReached = isRepeatable && remainingRepeats <= 0;
                  const alreadyAddedNonRepeatable = !isRepeatable && currentCount > 0;

                  // Check form restrictions (e.g., negative_immune)
                  const formRestricted = (selectedForm?.negative_immune && isNegative);

                  const isDisabled = !canAfford || maxReached || alreadyAddedNonRepeatable || formRestricted;

                  let buttonTitle = 'Add Effect';
                  if (isDisabled) {
                    if (formRestricted) buttonTitle = `Form '${selectedForm?.name}' cannot take negative effects`;
                    else if (!canAfford) buttonTitle = 'Not enough EP';
                    else if (maxReached) buttonTitle = `Max repetitions (${maxRepeats}) reached`;
                    else if (alreadyAddedNonRepeatable) buttonTitle = 'Cannot add again';
                  }

                  // --- Market Display Logic ---
                  const baseCost = effect.ahn_cost ?? 0;
                  const currentCost = effect.current_ahn_cost ?? baseCost; // Fallback to base if missing
                  const isOnSale = effect.sale_percent > 0;
                  const isMarkedUp = effect.markup_percent > 0;
                  // --- End Market Display Logic ---

                  return (
                    <Table.Row key={effect.id} style={{ borderBottom: '1px solid rgba(255, 255, 255, 0.05)' }}>
                      <Table.Cell py={1}>
                        <Box fontSize="medium" title={effect.desc || ''}>
                          {effect.name}
                          {/* Optional: Sale/Markup Badges */}
                          {isOnSale && <Box inline ml={1} px={0.5} backgroundColor="green" color="white" fontSize="tiny" style={{ borderRadius: '3px' }}>SALE</Box>}
                          {isMarkedUp && <Box inline ml={1} px={0.5} backgroundColor="red" color="white" fontSize="tiny" style={{ borderRadius: '3px' }}>UP</Box>}
                        </Box>
                        <Box color="label" fontSize="small" mt={0.5}>
                          {effect.desc || 'No description.'}
                        </Box>
                      </Table.Cell>
                      <Table.Cell collapsing>
                        {isRepeatable && (
                          <Box color="good" title={`Can be applied up to ${maxRepeats} times.`}>
                            Repeatable ({remainingRepeats} left)
                          </Box>
                        )}
                        {isNegative && (
                          <Box color={formRestricted ? 'grey' : 'bad'} title={formRestricted ? `Blocked by form '${selectedForm?.name}'` : 'Grants EP but may have downsides.'}>
                            Negative
                          </Box>
                        )}
                        {!isRepeatable && !isNegative && (
                          <Box color="label">-</Box>
                        )}
                      </Table.Cell>
                      {/* Cost Cell (UPDATED) */}
                      <Table.Cell collapsing textAlign="right">
                        <Box color={isOnSale ? 'good' : (isMarkedUp ? 'bad' : 'label')}>
                          {currentCost} {currencySymbol}
                        </Box>
                        {/* Show original price if different */}
                        {(isOnSale || isMarkedUp) && baseCost !== currentCost && (
                          <Box color="label" fontSize="tiny" style={{ textDecoration: 'line-through' }}>
                            ({baseCost})
                          </Box>
                        )}
                        {/* Show percentage */}
                        {isOnSale && <Box color="good" fontSize="tiny">({effect.sale_percent}% off)</Box>}
                        {isMarkedUp && <Box color="bad" fontSize="tiny">(+{effect.markup_percent}%)</Box>}
                      </Table.Cell>
                      <Table.Cell collapsing textAlign="right" color={effect.ep_cost > 0 ? 'bad' : (isNegative ? 'good' : 'label')}>
                        {effect.ep_cost > 0 ? `-${effect.ep_cost}` : (isNegative ? `+${Math.abs(effect.ep_cost)}` : '0')}
                      </Table.Cell>
                      <Table.Cell collapsing>
                        <Button
                          icon="plus"
                          title={buttonTitle}
                          disabled={isDisabled}
                          onClick={() => handleAddEffect(effect)} />
                      </Table.Cell>
                    </Table.Row>
                  );
                })
              )}
            </Table>
          </Section>
        </Box>

        {/* Selected Effects Column */}
        <Box flexBasis="50%" pl={1} overflowY="auto" ml={1}> {/* Added margin left */}
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
                  if (!effect) {
                    return (
                      <Table.Row key={`missing-${index}-${effectId}`}>
                        <Table.Cell colSpan={3} color="bad">Error: Effect data missing for ID {effectId}</Table.Cell>
                      </Table.Row>
                    ); 
                  }
                  const isNegative = effect.ep_cost < 0;
                  return (
                    <Table.Row key={`${effectId}-${index}`}>
                      <Table.Cell>{effect.name}</Table.Cell>
                      <Table.Cell collapsing textAlign="right" color={effect.ep_cost > 0 ? 'bad' : (isNegative ? 'good' : 'label')}>
                        {effect.ep_cost > 0 ? `-${effect.ep_cost}` : (isNegative ? `+${Math.abs(effect.ep_cost)}` : '0')}
                      </Table.Cell>
                      <Table.Cell collapsing>
                        <Button
                          icon="minus"
                          title="Remove Effect"
                          onClick={() => handleRemoveEffect(index)}
                          color="bad"
                          compact />
                      </Table.Cell>
                    </Table.Row>
                  );
                })}
              </Table>
            )}
          </Section>
        </Box>
      </Box> {/* End Flex container for columns */}

      {/* Bottom Buttons */}
      <Box borderTop={1} borderColor="rgba(255, 255, 255, 0.1)" mt={1} pt={1} display="flex" justifyContent="space-between">
        <Button
          icon="arrow-left"
          content="Back to Template"
          onClick={() => setPage('template')} />
        <Button
          icon="cog"
          content="Fabricate"
          color="good"
          // --- UPDATED: Disable check ---
          disabled={remainingEp < 0 || !selectedFormId || !isValidHex(primaryColor) || !isValidHex(secondaryColor)}
          onClick={handleFabricate} />
      </Box>
    </Box>
  );
};
