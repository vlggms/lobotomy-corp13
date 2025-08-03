import { useBackend, useLocalState } from '../backend';
import { Box, Button, Section } from '../components';
import { Window } from '../layouts';

export const KeyComboModal = (props, context) => {
  const { act, data } = useBackend(context);
  const [keysPressed, setKeysPressed] = useLocalState(context, 'keysPressed', []);
  const [keyCombo, setKeyCombo] = useLocalState(context, 'keyCombo', '');

  const handleKeyDown = e => {
    e.preventDefault();
    e.stopPropagation();

    const key = e.key;
    const code = e.code;
    
    // Build the key combination string
    let combo = '';
    if (e.altKey && key !== 'Alt') combo += 'Alt';
    if (e.ctrlKey && key !== 'Control') combo += 'Ctrl';
    if (e.shiftKey && key !== 'Shift') combo += 'Shift';
    
    // Add the actual key if it's not a modifier
    if (!['Alt', 'Control', 'Shift'].includes(key)) {
      // Use a more readable key name
      let keyName = key;
      if (code.startsWith('Key')) {
        keyName = code.substring(3).toUpperCase();
      } else if (code.startsWith('Digit')) {
        keyName = code.substring(5);
      } else if (code === 'Space') {
        keyName = 'Space';
      } else if (key.length === 1) {
        keyName = key.toUpperCase();
      }
      combo += keyName;
    }
    
    if (combo) {
      setKeyCombo(combo);
    }
  };

  const handleConfirm = () => {
    if (keyCombo) {
      act('set_keybind', { key: keyCombo });
    }
  };

  const handleCancel = () => {
    act('cancel');
  };

  return (
    <Window
      width={400}
      height={200}
      title="Bind Action to Key">
      <Window.Content>
        <Section fill>
          <Box mb={2}>
            Press any key combination to bind this action.
            You can use Ctrl, Alt, and Shift as modifiers.
          </Box>
          <Box
            backgroundColor="black"
            p={2}
            mb={2}
            textAlign="center"
            fontSize="20px"
            onKeyDown={handleKeyDown}
            tabIndex={0}
            style={{ outline: 'none' }}
            ref={el => el && el.focus()}>
            {keyCombo || 'Press a key...'}
          </Box>
          <Box mt={2}>
            <Button
              content="Confirm"
              color="good"
              disabled={!keyCombo}
              onClick={handleConfirm} />
            <Button
              content="Cancel"
              color="bad"
              onClick={handleCancel} />
          </Box>
        </Section>
      </Window.Content>
    </Window>
  );
};