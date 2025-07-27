import { useBackend } from '../backend';
import { Button, Section, Flex, Box } from '../components';
import { Window } from '../layouts';

export const AbnormalityQueue = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    current,
    threatcurrent,
    enablehardcore,
  } = data;

  const items = data.choices || [];

  return (
    <Window
      title="Abnormality Queue Console"
      width={360}
      height={400}>
      <Window.Content>
        <Flex direction="column" mb={1}>
          <Section
            title="Currently queued abnormality"
            bold
          ><Box as="span" color={data.colorcurrent}>[{threatcurrent}]</Box> {current}
          </Section>
        </Flex>
        <Section
          title="Available extraction options"
          scrollable>
          <Flex direction="column" mr={7}>
            <Flex
              mb={1}
              grow={1}
              direction="column"
              height="100%"
              justify="space-between">
              {items.map(item => (
                <Flex.Item key={item.name} grow={1} mb={0.3}>
                  <Button
                    icon="plus"
                    fluid
                    bold
                    content={"[" + data["threat" + item] + "] " + item}
                    color={data["color" + item]}
                    onClick={() => act("change_current", { change_current: data[item] })} />
                </Flex.Item>
              ))}
            </Flex>
          </Flex>
        </Section>
        <Section
          title="Dangerous Buttons"
          scrollable>
          <Flex direction="column" mr={7}>
            <Flex.Item grow={1} mb={0.3}>
              <Box
                bold>
                Lobotomy Corporation is not responsible for any lynching or
                Manager death as a result of using of the below buttons.
              </Box>
            </Flex.Item>
            <Flex.Item grow={1} mb={0.3}>
              <Button
                icon="bomb"
                fluid
                bold
                content={"Lets Roll"}
                color="green"
                onClick={() => act("lets_roll")} />
            </Flex.Item>
            <Flex.Item grow={1} mb={0.3}>
              <Button
                icon="bomb"
                fluid
                bold
                content={"Fuck It Lets Roll"}
                color="yellow"
                onClick={() => act("fuck_it_lets_roll")} />
            </Flex.Item>
            {!!data.enablehardcore && (
              <Flex.Item grow={1} mb={0.3}>
                <Button
                  icon="bomb"
                  fluid
                  bold
                  content={"Hardcore Fuck It Lets Roll"}
                  color="red"
                  onClick={() => act("hardcore_fuck_it_lets_roll")} />
              </Flex.Item>
            )}
          </Flex>
        </Section>
      </Window.Content>
    </Window>
  );
};
