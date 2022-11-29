import { useBackend } from '../backend';
import { Button, Section, Flex, Box } from '../components';
import { Window } from '../layouts';

export const AbnormalityQueue = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    current,
    threatcurrent,
  } = data;

  const items = data.choices || [];

  return (
    <Window
      title="Abnormality Queue Console"
      width={360}
      height={240}>
      <Window.Content>
        <Flex direction="column" height="35%">
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
      </Window.Content>
    </Window>
  );
};
