import { useBackend } from "../backend";
import { Box, Button, LabeledList, Section } from "../components";
import { Window } from "../layouts";

export const SpeakingNpc = (props, context) => {
  const { act, data } = useBackend(context);
  const { title, text } = data;
  return (
    <Window title={title}>
      <Window.Content>
        <Section>
          <Box style={{ whiteSpace: "pre-wrap" }}>{text}</Box>
          <LabeledList>
            <LabeledList.Item label="Actions">
              <Button onClick={() => act("talk")}>Talk</Button>
              <Button onClick={() => act("pet")}>Pet</Button>
              <Button onClick={() => act("close")}>Close</Button>
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
