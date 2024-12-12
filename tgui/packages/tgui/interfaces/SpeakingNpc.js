import { useBackend } from "../backend";
import { Box, Button, LabeledList, Flex, Section } from "../components";
import { Window } from "../layouts";
import { TypingScroller } from "../components";

export const SpeakingNpc = (props, context) => {
  const { act, data } = useBackend(context);
  const { title = "", text = "", img_url = "", actions = {} } = data || {};
  return (
    <Window title={title}>
      <Window.Content>
        <Section>
        <Flex direction="column" height="100%">
          <Flex.Item>
            <Flex direction="row" align="start">
                {img_url && (
                  <Flex.Item mr={1}>
                    <img class="fit-picture" width="192" height="192" src={img_url} style={{ flex: 0 }} />
                  </Flex.Item>
                )}
                <Flex.Item grow={1}>
                  <TypingScroller key={text} text={text} speed={100}
                    onTypingStart={() => act("playSound")}
                    onTypingEnd={() => act("stopSound")}/>
                </Flex.Item>
              </Flex>
            </Flex.Item>
            <Flex.Item mt={2}>
              <Flex
                direction="column"
                align="center"
                justify="center"
                height="100%"
              >
                {actions.map((action) => (
                  <Button
                    key={action.key}
                    onClick={() => act(action.key)}
                    fontSize="14px"
                    width="150px"
                    height="30px"
                    mb={1}
                  >
                    {action.text}
                  </Button>
                ))}
              </Flex>
            </Flex.Item>
          </Flex>        </Section>
      </Window.Content>
    </Window>
  );
};
